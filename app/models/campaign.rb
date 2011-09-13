class Campaign < ActiveRecord::Base

  acts_as_indexed :fields => [:title]
  has_many :offices

  validates :title, :presence => true, :uniqueness => true
  
end
