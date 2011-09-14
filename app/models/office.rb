class Office < ActiveRecord::Base

  acts_as_indexed :fields => [:title]
  has_many :candidates, :dependent => :destroy
  belongs_to :ballot
  
  validates :title, :presence => true
  
  accepts_nested_attributes_for :candidates,
      :reject_if => lambda { |attrs| attrs[:name].blank? },
      :allow_destroy => true
  
end
