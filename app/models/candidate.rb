class Candidate < ActiveRecord::Base

  acts_as_indexed :fields => [:name]
  belongs_to :office
  
  validates :name, :presence => true
  
end
