require 'spec_helper'
require 'spec/factories/all'

describe Ballot do
    
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
  
  specify 'its start date must be after its end date' do
    get_ballot(:start_date => 1.day.from_now, :end_date => 1.day.ago).should_not be_valid
  end
  
  
  describe 'open/closed' do
    tuesday   = Time.now
    wednesday = tuesday + 100
    thursday  = wednesday + 100
  
    shared_examples_for 'an open election' do
      before(:each) { Time.stub!(:now).and_return(wednesday) }
      it { should be_open_for_voting }
      it { should_not be_too_early_to_vote }
      it { should_not be_too_late_to_vote }
    end
    
    context 'when today is before the start date' do
      before(:each) { Time.stub!(:now).and_return(tuesday) }
      subject { get_ballot :start_date => wednesday, :end_date => thursday }
      it { should_not be_open_for_voting }
      it { should be_too_early_to_vote }
      it { should_not be_too_late_to_vote }
    end
  
    context 'when today is on the start date' do
      subject { get_ballot :start_date => wednesday, :end_date => thursday }
      it_should_behave_like 'an open election'
    end
  
    context 'when today is on the end date' do
      subject { get_ballot :end_date => wednesday, :end_date => thursday }
      it_should_behave_like 'an open election'
    end
  
    context 'when today is within the start and end dates' do
      subject { get_ballot :start_date => tuesday, :end_date => thursday }
      it_should_behave_like 'an open election'
    end
    
    context 'when today is after the end date' do
      before(:each) { Time.stub!(:now).and_return(thursday) }
      subject { get_ballot :start_date => tuesday, :end_date => wednesday }
      it { should_not be_open_for_voting }
      it { should_not be_too_early_to_vote }
      it { should be_too_late_to_vote }
    end
  end
  
  it "can find members who have and haven't voted on it" do
    ballot = Factory.create_whole_ballot
    member1, member2 = get_member!, get_member!
    vote = BallotVote.new_for_ballot ballot
    vote.member = member1
    vote.save!
    ballot.voting_members.to_a.should == [member1]
    ballot.nonvoting_members.to_a.should == [member2]
  end
  
end
