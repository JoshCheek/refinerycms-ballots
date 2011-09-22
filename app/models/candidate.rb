class Candidate < ActiveRecord::Base

  acts_as_indexed :fields => [:name]
  belongs_to :office
  has_many :candidate_votes
  
  validates :name, :presence => true
  
  def percentage
    return 0 if number_of_votes.zero?
    100 * number_of_votes / number_of_voters
  end

  def number_of_votes
    candidate_votes.where(:voted => true).count
  end
  
  def number_of_voters
    candidate_votes.count
  end

end
