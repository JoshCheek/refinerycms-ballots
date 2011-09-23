require 'spec/factories/all'


Given /^I have no ballots, offices, or candidates$/ do
  Ballot.delete_all
  Office.delete_all
  Candidate.delete_all
end

Given /^I (only )?have ballots titled "?([^\"]*)"?$/ do |only, titles|
  Ballot.delete_all if only
  titles.split(', ').each do |title|
    get_ballot!(:title => title)
  end
end

Then /^I should have ([0-9]+) ballots?$/ do |count|
  Ballot.count.should == count.to_i
end



Then /^I should be able to add a ballot$/ do |table|
  init_hash = table.hashes.first
  ballot = get_ballot init_hash
  lambda { ballot.save! }.should_not raise_error
  ballot.pretty_start_date.should == init_hash[:start_date]
  ballot.pretty_end_date.should == init_hash[:end_date]
  ballot.title.should == init_hash[:title]
end

Given /^a Ballot$/ do
  @ballot = get_ballot!
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
  @office = get_office! :ballot => @ballot
end

Then /^I should be able to add candidates$/ do |candidates|
  candidates.hashes.each { |candidate| @office.candidates.build candidate }
  @office.save!
  Candidate.count.should == 3
  Candidate.all.map(&:name).sort.should == candidates.hashes.map { |hash| hash[:name] }.sort
end

Given /^I can create a ballot that accepts nested attributes for offices and candidates$/ do
  Given "I have no ballots, offices, or candidates"
  Factory.create_whole_ballot
  Ballot.count.should == 1
  Office.count.should == 3
  Candidate.count.should == 8
  Member.count.should == 0
end

Given /^a ballot with multiple offices and candidates$/ do
  Factory.create_whole_ballot
end

When /^I view the admin ballot$/ do
  visit admin_ballot_path Ballot.last
end

Then /^I should see all the offices and candidates$/ do
  ballot = Ballot.last
  page.should have_content(ballot.title)
  ballot.offices.map(&:title).each do |title|
    page.should have_content title
  end
end

