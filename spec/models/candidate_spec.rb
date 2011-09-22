require 'spec_helper'
require 'spec/factories/candidate'
require 'spec/factories/candidate_vote'

describe Candidate do
  def get_candidate(options={})
    Factory.build :candidate, options
  end
  
  def get_candidate!(options={})
    candidate = get_candidate options
    candidate.save!
    candidate
  end
  
  def get_candidate_vote!(options={})
    Factory.create :candidate_vote, options
  end
  
  
  it 'must have a name' do
    get_candidate(:name => nil).should_not be_valid
  end
  
  describe '#percentage' do
    it 'is zero when there are no voters' do
      get_candidate.percentage.should == 0
    end
    
    it "is the candidate's total number of votes divided by their total number of possible votes (num voters)" do
      candidate = get_candidate
      candidate.stub!(:number_of_votes).and_return 3
      candidate.stub!(:number_of_voters).and_return 10
      candidate.percentage.should == 30
    end
    
    it 'is rounded down to the nearest integer' do
      candidate = get_candidate
      candidate.stub!(:number_of_votes).and_return 3
      candidate.stub!(:number_of_voters).and_return 9
      candidate.percentage.should == 33
    end
  end
  
  specify 'its number of *voters* is the number of candidates that could have voted for it' do
    candidate = get_candidate!
    candidate.number_of_voters.should == 0
    get_candidate_vote!(:candidate => candidate, :voted => true)
    candidate.number_of_voters.should == 1
    get_candidate_vote!(:candidate => candidate, :voted => false)
    candidate.number_of_voters.should == 2
  end
  
  specify 'its number of *votes* is the number of candidates that have voted for it' do
    candidate = get_candidate!
    candidate.number_of_votes.should == 0
    get_candidate_vote!(:candidate => candidate, :voted => true)
    candidate.number_of_votes.should == 1
    get_candidate_vote!(:candidate => candidate, :voted => false)
    candidate.number_of_votes.should == 1
  end
end
