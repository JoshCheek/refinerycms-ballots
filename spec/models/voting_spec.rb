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
  
  before :each do
    [BallotVote, OfficeVote, CandidateVote].each(&:delete_all)
  end
  
  let(:member) { Member.create! :unique_identifier => 'A123'; Member.last }
  
  specify 'members can cast votes for candidates' do
    bv = BallotVote.new :member => member
    president = bv.office_votes.build :office => Office.find_by_title('President')
    president.candidate_votes.build :candidate => Candidate.find_by_name('Bradford')
    bv.save!
    member.ballot_votes.count.should == 1
    BallotVote.count.should == 1
    OfficeVote.count.should == 1
    CandidateVote.count.should == 1
    Candidate.find_by_name('Bradford').number_of_votes.should == 1
  end
  
  specify 'cannot overvote' do
    bv = BallotVote.new :member => member
    president = bv.office_votes.build :office => Office.find_by_title('President')
    president.candidate_votes.build :candidate => Candidate.find_by_name('Bradford')
    president.should be_valid
    president.candidate_votes.build :candidate => Candidate.find_by_name('Gary')
    president.should_not be_valid
    bv.save.should be_false
    BallotVote.count.should == 0
    OfficeVote.count.should == 0
    CandidateVote.count.should == 0
    Candidate.find_by_name('Bradford').number_of_votes.should == 0
  end
  
  specify 'can undervote' do
    bv = BallotVote.new :member => member
    president = bv.office_votes.build :office => Office.find_by_title('President')
    president.should be_valid
    bv.save.should be
    BallotVote.count.should == 1
    OfficeVote.count.should == 1
    CandidateVote.count.should == 0
  end
  
end
