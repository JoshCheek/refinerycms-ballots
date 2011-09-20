class Ballot < ActiveRecord::Base

  acts_as_indexed :fields => [:title]
  has_many :offices, :dependent => :destroy

  validates :title, :presence => true, :uniqueness => true
  
  accepts_nested_attributes_for :offices, 
      :reject_if => lambda { |attrs| attrs[:title].blank? },
      :allow_destroy => true
  
  def pretty_start_date
    pretty_date start_date
  end
  
  def pretty_end_date
    pretty_date end_date
  end
  
  def pretty_date(date)
    date.strftime "%Y-%m-%d"
  end
  
  def open_for_voting?
    today = Time.now
    start_date < today && today < end_date
  end
end
