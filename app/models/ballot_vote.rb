class BallotVote < ActiveRecord::Base
  belongs_to :member
  belongs_to :ballot
  has_many :office_votes
  validates_associated :office_votes
  
  accepts_nested_attributes_for :office_votes, :allow_destroy => true
  
end

class Member < ActiveRecord::Base
  has_many :ballot_votes
end
