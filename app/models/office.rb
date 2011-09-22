class Office < ActiveRecord::Base

  acts_as_indexed :fields => [:title]
  has_many :candidates, :dependent => :destroy
  belongs_to :ballot
  
  validates :title, :presence => true

  
  validates_numericality_of :number_of_positions, :only_integer => true, :message => "is the number of people who can be elected to this office (an integer)."
  
  accepts_nested_attributes_for :candidates,
      :reject_if => lambda { |attrs| attrs[:name].blank? },
      :allow_destroy => true
      
  def candidates_by_rating
    candidates.sort_by { |candidate| candidate.number_of_votes }.reverse
  end
  
end
