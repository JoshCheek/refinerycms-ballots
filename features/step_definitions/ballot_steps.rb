
Given /^I have no ballots, offices, or candidates$/ do
  Ballot.delete_all
  Office.delete_all
  Candidate.delete_all
end

Given /^I (only )?have ballots titled "?([^\"]*)"?$/ do |only, titles|
  Ballot.delete_all if only
  titles.split(', ').each do |title|
    Ballot.create(:title => title)
  end
end

Then /^I should have ([0-9]+) ballots?$/ do |count|
  Ballot.count.should == count.to_i
end



Then /^I should be able to add a ballot$/ do |table|
  ballot = Ballot.new table.hashes.first
  lambda { ballot.save! }.should_not raise_error
end

Given /^a Ballot$/ do
  @ballot = Ballot.new :title => '2012 election', :start_date => 10.days.ago, :end_date => 10.days.from_now
  @ballot.save!
end

Then /^I should be able to add offices$/ do |table|
  @ballot.save
  table.hashes.each do |init_hash|
    lambda { @ballot.offices.create init_hash }.should_not raise_error
  end
  offices = Office.all
  offices.size.should == 2
  table.hashes.each_with_index do |init_hash, index|
    offices[index].title.should == init_hash[:title]
    offices[index].number_of_positions.should == init_hash[:number_of_positions].to_i
  end
end

Given /^a ballot with an office$/ do
  Given "a Ballot"
  @office = @ballot.offices.build
  @office.title = "President"
  @office.number_of_positions = 1
  lambda { @office.save! }.should_not raise_error
end

Then /^I should be able to add candidates$/ do |candidates|
  candidates.hashes.each { |candidate| @office.candidates.build candidate }
  @office.save!
  Candidate.count.should == 3
  Candidate.all.map(&:name).sort.should == candidates.hashes.map { |hash| hash[:name] }.sort
end
