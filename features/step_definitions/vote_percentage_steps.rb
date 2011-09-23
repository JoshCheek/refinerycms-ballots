require 'spec/factories/all'


Given /^a (\d+) person election, with (\d+) positions? available$/ do |num_candidates, num_positions, table|
  [Ballot, Office, Candidate].each(&:delete_all)
  @ballot = get_ballot!
  @office = get_office! :ballot => @ballot, :number_of_positions => num_positions.to_i
  @candidates = table.raw.map { |(name)| get_candidate! :office => @office, :name => name.strip }
  @ballot.save!
end


Given /^(\d+) (?:people|person) votes? for (\w+)$/ do |n, name|
  n.to_i.times do
    ballot_vote = BallotVote.new_for_ballot @ballot
    ballot_vote.member = get_member
    vote_for(ballot_vote, [name])
    ballot_vote.save!
  end
end

def get_candidate_vote(ballot_vote, name)
  ballot_vote.office_votes.first.candidate_votes.to_a.find do |candidate_vote|
    candidate = candidate_vote.candidate
    candidate.name == name
  end
end

def vote_for(ballot_vote, names)
  return if names.first == 'neither'
  names.each do |name|
    candidate_vote = get_candidate_vote ballot_vote, name
    candidate_vote.vote
  end
end


Then /^election Results should be$/ do |table|
  table.hashes.each do |expectations|
    candidate = Candidate.find_by_name expectations[:candidate]
    candidate.number_of_votes.should == expectations[:votes].to_i
    candidate.percentage.should == expectations[:percentage].to_i
  end
end

Given /^\w+ votes for (.*)$/ do |votees|
  ballot_vote = BallotVote.new_for_ballot @ballot
  ballot_vote.member = get_member
  vote_for ballot_vote, votees.split(", ")
  ballot_vote.save
end

Then /^total votes should be (\d+)$/ do |n|
  @ballot.number_of_votes.should == n.to_i
end

Then /^total people voted should be (\d+)$/ do |n|
  @ballot.number_of_voters.should == n.to_i
end
