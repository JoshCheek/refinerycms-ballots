Member # force autoloading to load the file

class Member < ActiveRecord::Base
  has_many :ballot_votes
  
  def number_of_times_voted
    ballot_votes.count
  end
  
  def has_voted_on?(ballot)
    ballot_votes.where(:ballot_id => ballot.id).any?
  end
end

