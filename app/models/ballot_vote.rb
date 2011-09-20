class BallotVote < ActiveRecord::Base
  belongs_to :member
  belongs_to :ballot
  has_many :office_votes
  validates_associated :office_votes
  validate :ballot_must_be_open_for_voting
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
  
    def ballot_must_be_open_for_voting
      return if ballot.open_for_voting?
      end_date = ballot.end_date.strftime '%d %b %Y' # might not be accurate enough at boundary dates
      errors[:base] << "This ballot closed for voting on #{end_date}."
    end
end


class Member < ActiveRecord::Base
  has_many :ballot_votes
end
