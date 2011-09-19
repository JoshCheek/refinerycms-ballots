class OfficeVote < ActiveRecord::Base
  belongs_to :ballot_vote
  belongs_to :office
  has_many :candidate_votes
  validate :cannot_overvote
  
  accepts_nested_attributes_for :candidate_votes,
      # :reject_if => lambda { |attrs| attrs[:title].blank? },
      :allow_destroy => true
  
  def title
    office && office.title
  end
  
  def cannot_overvote
    if num_votes > max_num_votes
      errors[:base] << "Cannot vote for #{num_votes}, maximum is #{max_num_votes}"
    end
  end
  
  def num_votes
    candidate_votes.select { |cv| cv.voted? }.size
  end
  
  def max_num_votes
    office.number_of_positions
  end
end

