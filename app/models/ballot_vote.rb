class BallotVote < ActiveRecord::Base
  belongs_to :member
  belongs_to :ballot
  has_many :office_votes
  validates_associated :office_votes
  
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
end


class Member < ActiveRecord::Base
  has_many :ballot_votes
end
