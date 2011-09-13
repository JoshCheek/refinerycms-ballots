class Candidate < ActiveRecord::Base

  acts_as_indexed :fields => [:name]
  belongs_to :office
  
  validates :title, :presence => true, :uniqueness => true
  
end
