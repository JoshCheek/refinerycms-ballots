class OfficeVote < ActiveRecord::Base
  belongs_to :ballot_vote
  belongs_to :office
  has_many :candidate_votes
  validate :cannot_overvote
  
  accepts_nested_attributes_for :candidate_votes, :allow_destroy => true
  
  def title
    office && office.title
  end
    
  def num_votes
    candidate_votes.select { |cv| cv.voted? }.size
  end
  
  def max_num_votes
    (office && office.number_of_positions) || 0
  end
  
  def tampered?(ballot)
    !office || office.ballot != ballot || candidate_votes.any? { |candidate_vote| candidate_vote.tampered? office }
  end
  
  private
  
    def cannot_overvote
      if num_votes > max_num_votes
        errors[:base] << "Cannot vote for #{num_votes}, maximum is #{max_num_votes}"
      end
    end
  
end
