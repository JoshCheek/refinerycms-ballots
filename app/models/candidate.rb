class Candidate < ActiveRecord::Base

  acts_as_indexed :fields => [:name]
  belongs_to :office
  has_many :candidate_votes
    
  validates :name, :presence => true

  def number_of_votes
    candidate_votes.where(:voted => true).count
  end  
end

