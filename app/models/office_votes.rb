class OfficeVote < ActiveRecord::Base
  belongs_to :ballot_vote
  belongs_to :office
  has_many :candidate_votes
  validate :cannot_overvote
  
  def cannot_overvote
    if num_votes > max_num_votes
      errors[:base] << "Cannot vote for #{num_votes}, maximum is #{max_num_votes}"
    end
  end
  
  def num_votes
    # count apparently queries db, size is for in-memory associations
    candidate_votes.size
  end
  
  def max_num_votes
    office.number_of_positions
  end
end
