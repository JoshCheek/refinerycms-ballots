describe 'Voting' do
  
  # ensure db is set up right
  before :each do
    [Ballot, Office, Candidate, Member].each(&:delete_all)
    Ballot.create  "title"=>"2012 election",
                   "start_date(1i)"=>"2012",
                   "start_date(2i)"=>"1",
                   "start_date(3i)"=>"14",
                   "start_date(4i)"=>"15",
                   "start_date(5i)"=>"09",
                   "end_date(1i)"=>"2012",
                   "end_date(2i)"=>"2",
                   "end_date(3i)"=>"14",
                   "end_date(4i)"=>"15",
                   "end_date(5i)"=>"09",
                   "offices_attributes"=>
                    {"0"=>
                      {"_destroy"=>"false",
                       "title"=>"President",
                       "number_of_positions"=>"1",
                       "candidates_attributes"=>
                        {"0"=>{"name"=>"Bradford", "_destroy"=>"false"},
                         "1316013000645"=>{"name"=>"Gary", "_destroy"=>"false"}}},
                     "1316013014442"=>
                      {"_destroy"=>"false",
                       "title"=>"Vice President",
                       "number_of_positions"=>"1",
                       "candidates_attributes"=>
                        {"0"=>{"name"=>"Jim", "_destroy"=>"false"},
                         "1316013025758"=>{"name"=>"Cara", "_destroy"=>"false"}}},
                     "1316013254746"=>
                      {"_destroy"=>"false",
                       "title"=>"Board of Directors",
                       "number_of_positions"=>"2",
                       "candidates_attributes"=>
                        {"0"=>{"name"=>"Joe", "_destroy"=>"false"},
                         "1316013264883"=>{"name"=>"Bob", "_destroy"=>"false"},
                         "1316013267758"=>{"name"=>"Pete", "_destroy"=>"false"},
                         "1316013271569"=>{"name"=>"Uma", "_destroy"=>"false"}}}}
    Ballot.count.should == 1
    Office.count.should == 3
    Candidate.count.should == 8
    Member.count.should == 0
  end
  
  let(:member)    { Member.create! :unique_identifier => 'A123'; Member.last }
  let(:bv)        { BallotVote.new_for_ballot Ballot.first }
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
end
