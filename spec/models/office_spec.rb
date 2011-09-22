describe Office do
  
  it 'must have a title' do
    get_office(:title => nil).should_not be_valid
    get_office(:title => '').should_not be_valid
  end
  
  it 'has a number of positions that are available' do
    office = get_office!(:number_of_positions => 5)
    office.number_of_positions.should == 5
  end
  
  specify 'its default number of positions is 1' do
    Office.new.number_of_positions.should == 1
  end
  
  it 'is invalid if number_of_positions is not an integer' do
    get_office(:number_of_positions => "1").should be_valid
    get_office(:number_of_positions => "1123").should be_valid
    
    get_office(:number_of_positions => "1.23").should_not be_valid
    get_office(:number_of_positions => "1abc").should_not be_valid
    get_office(:number_of_positions => "abc1").should_not be_valid
    get_office(:number_of_positions => "abc").should_not be_valid
  end
  
  
  def apply_votes(candidates_and_votes)
    candidates_and_votes.each do |candidate, votes|
      votes.times { get_candidate_vote! :candidate => candidate, :voted => true }
    end
  end
  
  it 'can get its candidates by their rating' do
    office = get_office!
    candidate1 = get_candidate! :office => office
    candidate2 = get_candidate! :office => office
    candidate3 = get_candidate! :office => office
    apply_votes candidate1 => 1, candidate2 => 3, candidate3 => 2
    office.candidates_by_rating.should == [candidate2, candidate3, candidate1]
  end
end

