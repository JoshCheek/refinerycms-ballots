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
  
end

