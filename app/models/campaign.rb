class Campaign < ActiveRecord::Base

  acts_as_indexed :fields => [:title]
  has_many :offices, :dependent => :destroy

  validates :title, :presence => true, :uniqueness => true
  
  accepts_nested_attributes_for :offices, 
      :reject_if => lambda { |attrs| attrs[:title].blank? },
      :allow_destroy => true
end
