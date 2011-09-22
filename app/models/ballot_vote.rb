class BallotVote < ActiveRecord::Base
  belongs_to :member
  belongs_to :ballot
  has_many :office_votes
  has_many :candidate_votes, :through => :office_votes
  validates_associated :office_votes
  validate :ballot_must_be_open_for_voting
  validate :member_vote_must_be_unique
  
  accepts_nested_attributes_for :office_votes, :allow_destroy => true

  def self.new_for_ballot(ballot)
    bv = BallotVote.new :ballot => ballot
    ballot.offices.each do |office|
      ov = bv.office_votes.build :office => office
      office.candidates.each do |candidate|
        ov.candidate_votes.build :candidate => candidate
      end
    end
    bv
  end  
  
  def tampered?
    !ballot || office_votes.any? { |office_vote| office_vote.tampered? ballot }
  end
  
  private
    def member_vote_must_be_unique
      count = BallotVote.where(:member_id => member_id, :ballot_id => ballot_id).count
      return if count.zero?
      errors[:base] << "You cannot vote twice"
    end
  
    def ballot_must_be_open_for_voting
      return if ballot.open_for_voting?
      end_date = ballot.end_date.strftime '%d %b %Y' # might not be accurate enough at boundary dates
      errors[:base] << "This ballot closed for voting on #{end_date}."
    end
end

Member # force autoloading to load the file
class Member
  has_many :ballot_votes
  
  def number_of_times_voted
    ballot_votes.count
  end
end
