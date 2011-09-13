class Office < ActiveRecord::Base

  acts_as_indexed :fields => [:title]
  has_many :candidates
  belongs_to :campaign
  
  validates :title, :presence => true, :uniqueness => false
  
end
