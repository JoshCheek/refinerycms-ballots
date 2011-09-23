require 'spec/factories/all'


Given /^a member "(\w+)"$/ do |unique_identifier|
  Member.delete_all
  Member.create! :unique_identifier => unique_identifier
end

When /^I try to vote with "(\w+)"/ do |unique_identifier|
  pending
  visit "login_ballot_votes_path"
end


Then /^I am redirected to (.*)$/ do |page_name|
  Then "I should be on #{page_name}"
end

Then /^I make a logger$/ do
  $joshlog = Object.new.instance_eval do
    def puts(msg)
      File.open("JOSHLOG",'a') { |f| f.puts msg }
    end
    self
  end
end



Then /^I am( not)? allowed to vote$/ do |not_allowed|
  pending
  if not_allowed
    # redirected back to login page
  else
    # forwarded to vote page
  end
end

Given /^I vote$/ do
  pending
end

Then /^"([^"]*)" has voted once$/ do |unique_identifier|
  Member.find_by_unique_identifier(unique_identifier).number_of_times_voted.should == 1
end

