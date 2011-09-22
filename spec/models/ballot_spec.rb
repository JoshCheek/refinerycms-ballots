require 'spec_helper'
require 'spec/factories/ballot'

describe Ballot do
  
  def get_ballot(options={})
    Factory.build :ballot, options
  end
  
  def get_ballot!(options={})
    ballot = get_ballot(options)
    ballot.save!
    ballot
  end
  
  it 'has offices and destroys them when it is destroyed' do
    ballot = get_ballot!
    ballot.offices.create! Factory.attributes_for(:office)
    Office.count.should == 1
    ballot.destroy
    Office.count.should == 0
  end
  
  it 'must have a title' do
    -> { get_ballot(:title => nil).save! }.should raise_error
  end

  it 'formats the start date' do
    ballot = get_ballot :start_date => Date.parse('1/1/2012')
    ballot.pretty_start_date.should == '2012-01-01'
  end
  
  it 'formats the end date' do
    ballot = get_ballot :end_date => Date.parse('1/1/2012')
    ballot.pretty_end_date.should == '2012-01-01'
  end
  
  context 'is open for voting when' do
    specify 'today is on the start date' do
      time = Time.now
      Time.stub!(:now).and_return(time)
      ballot = get_ballot :start_date => time
      ballot.should be_open_for_voting
    end
    
    specify 'today is on the end date' do
      time = Time.now
      Time.stub!(:now).and_return(time)
      ballot = get_ballot :end_date => time
      ballot.should be_open_for_voting
    end
    
    specify 'today is within the start and end dates' do |variable|
      ballot = get_ballot :start_date => 10.days.ago, :end_date => 10.days.from_now
      ballot.should be_open_for_voting
    end
  end
    
end
