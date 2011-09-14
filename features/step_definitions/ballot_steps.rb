Given /^I have no ballots$/ do
  Ballot.delete_all
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
