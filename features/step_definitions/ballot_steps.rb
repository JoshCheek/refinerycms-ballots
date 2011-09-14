def nested_creation_hash
  {"title"=>"2009 Election",
   "start_date(1i)"=>"2008",
   "start_date(2i)"=>"9",
   "start_date(3i)"=>"14",
   "start_date(4i)"=>"14",
   "start_date(5i)"=>"44",
   "end_date(1i)"=>"2008",
   "end_date(2i)"=>"10",
   "end_date(3i)"=>"14",
   "end_date(4i)"=>"14",
   "end_date(5i)"=>"44",
   "offices_attributes"=>
    {"0"=>
      {"_destroy"=>"false",
       "title"=>"President",
       "number_of_positions"=>"1",
       "candidates_attributes"=>
        {"0"=>{"name"=>"Barack Obama", "_destroy"=>"false"},
         "1316011494172"=>{"name"=>"John McCain", "_destroy"=>"false"}}},
     "1316011498910"=>
      {"_destroy"=>"false",
       "title"=>"Vice President",
       "number_of_positions"=>"1",
       "candidates_attributes"=>
        {"0"=>{"name"=>"Joe Biden", "_destroy"=>"false"},
         "1316011508156"=>{"name"=>"Sarah Palin", "_destroy"=>"false"}}}}}
end


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
  init_hash = table.hashes.first
  ballot = Ballot.new init_hash
  lambda { ballot.save! }.should_not raise_error
  ballot.pretty_start_date.should == init_hash[:start_date]
  ballot.pretty_end_date.should == init_hash[:end_date]
  ballot.title.should == init_hash[:title]
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

Given /^I can create a ballot that accepts nested attributes for offices and candidates$/ do
  Given "I have no ballots, offices, or candidates"
  Ballot.create(nested_creation_hash)
  ballot = Ballot.first
  ballot.title.should == nested_creation_hash['title']
  ballot.should have(2).offices
  ballot.offices.each { |office| office.should have(2).candidates }
end

Given /^a ballot with multiple offices and candidates$/ do
  Ballot.create nested_creation_hash
end

When /^I view the ballot$/ do
  visit ballot_path Ballot.last
end

Then /^I should see all the offices and candidates$/ do
  page.should have_content(nested_creation_hash['title'])
  default_office_titles.each do |title|
    page.should have_content title
  end
end

def default_office_titles
  nested_creation_hash['offices_attributes'].map { |id, attrs| attrs['title'] }.reject(&:blank?)
end
