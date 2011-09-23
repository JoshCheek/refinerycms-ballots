require 'spec_helper'
require 'spec/factories/all'

describe 'Voting' do
  
  # ensure db is set up right
  before :each do
    [Ballot, Office, Candidate, Member].each(&:delete_all)
    Factory.create_whole_ballot
    
    # just to make sure it does what we think it should
    Ballot.count.should == 1
    Office.count.should == 3
    Candidate.count.should == 8
    Member.count.should == 0
  end
  
  let(:ballot)    { Ballot.first}
  let(:bv)        { BallotVote.new_for_ballot ballot }
  let(:member)    { get_member! :unique_identifier => 'A123' }
  let(:president) { bv.office_votes.to_a.find { |ov| ov.office.title == 'President' } }
  let(:bradford)  { president.candidate_votes.to_a.find { |cv| cv.candidate.name == 'Bradford' } }
  let(:gary)      { president.candidate_votes.to_a.find { |cv| cv.candidate.name == 'Gary' } }
  
  before :each do
    [BallotVote, OfficeVote, CandidateVote].each(&:delete_all)
    bv.member = member
  end
  
  specify 'members can cast votes for candidates' do
    bradford.vote
    bv.save!
    member.ballot_votes.count.should == 1
    BallotVote.count.should == 1
    OfficeVote.count.should == 3
    CandidateVote.count.should == 8
    Candidate.find_by_name('Bradford').number_of_votes.should == 1
  end
  
  specify 'cannot overvote' do
    bradford.vote
    president.should be_valid
    gary.vote
    president.should_not be_valid
    bv.save.should be_false
    BallotVote.count.should == 0
    OfficeVote.count.should == 0
    CandidateVote.count.should == 0
    Candidate.find_by_name('Bradford').number_of_votes.should == 0
    Candidate.find_by_name('Gary').number_of_votes.should == 0
  end
  
  specify 'can undervote' do
    president.should be_valid
    bv.save.should be
    Candidate.find_by_name('Bradford').number_of_votes.should == 0
    Candidate.find_by_name('Gary').number_of_votes.should == 0
  end
  
  describe 'voting times' do
    let(:ballot) { Ballot.new :start_date => 10.days.ago, :end_date => 10.days.from_now }
    let(:ballot_vote) { BallotVote.new_for_ballot ballot }
    
    specify 'cannot vote before the window' do
      ballot.start_date = 1.day.from_now
      ballot_vote.should_not be_valid
    end
    
    specify 'can vote in the window' do
      ballot_vote.should be_valid
    end
    
    specify 'cannot vote after the window' do
      ballot.end_date = 1.day.ago
      ballot_vote.should_not be_valid
    end
  end
  
  
  describe 'tamper detection' do
    specify "the office_vote must be pointing to an office that belongs to the ballot_vote's ballot" do
      ballot1 = Ballot.create!          :title => 'election1', :start_date => 10.days.ago, :end_date => 10.days.ago
      office1 = ballot1.offices.create! :title => 'office1', :number_of_positions => 10
      ballot2 = Ballot.create!          :title => 'election2', :start_date => 10.days.ago, :end_date => 10.days.ago
      office2 = ballot2.offices.create! :title => 'office2', :number_of_positions => 10
      ballot1.save!
      ballot2.save!
      bv = BallotVote.new_for_ballot ballot1
      bv.should_not be_tampered
      bv.office_votes.first.office = office2
      bv.should be_tampered
    end
    
    specify "The candidate_vote must be pointing to a candidate that belongs to the office_vote's office" do
      ballot1     = Ballot.create!            :title => 'election1', :start_date => 10.days.ago, :end_date => 10.days.ago
      office1     = ballot1.offices.create!   :title => 'office1', :number_of_positions => 10
      candidate1  = office1.candidates.build  :name => 'candidate1'
      ballot2     = Ballot.create!            :title => 'election2', :start_date => 10.days.ago, :end_date => 10.days.ago
      office2     = ballot2.offices.create!   :title => 'office2', :number_of_positions => 10
      candidate2  = office2.candidates.build  :name => 'candidate2'
      ballot1.save!
      ballot2.save!
      bv = BallotVote.new_for_ballot ballot1
      bv.should_not be_tampered
      bv.office_votes.first.candidate_votes.first.candidate = candidate2
      bv.should be_tampered
    end
  end
  
end
