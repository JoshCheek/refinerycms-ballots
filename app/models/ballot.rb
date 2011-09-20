class Ballot < ActiveRecord::Base

  acts_as_indexed :fields => [:title]
  has_many :offices, :dependent => :destroy
  has_many :ballot_votes
  has_many :candidate_votes, :through => :ballot_votes # this will work in rails 3.1, but not 3.0.10, at which time, we can change the implementation of number_of_votes

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

  def number_of_votes
    sums = ballot_votes.map do |ballot_vote|
      ballot_vote.candidate_votes.where(:voted => true).count
    end
    sums.inject :+
  end
    
  def number_of_voters
    ballot_votes.count
  end
  
end
