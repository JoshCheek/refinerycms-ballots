require 'spec_helper'
require 'spec/factories/candidate'

describe Candidate do
  def get_candidate(options={})
    Factory.build :candidate, options
  end
  
  it 'must have a name' do
    get_candidate(:name => nil).should_not be_valid
  end
  
  describe '#percentage' do
    it 'is zero when there are no voters'
    it "is the candidate's total number of votes divided by their total number of possible votes (num voters)"
  end
end

#   validates :name, :presence => true
# 
#   def percentage
#     return 0 if number_of_votes.zero?
#     100 * number_of_votes / number_of_voters
#   end
# 
#   def number_of_votes
#     candidate_votes.where(:voted => true).count
#   end
#   
#   def number_of_voters
#     candidate_votes.count
#   end
# 
# end
