def get_candidate_vote(options={})
  Factory.build :candidate_vote, options
end

def get_candidate_vote!(options={})
  candidate_vote = get_candidate_vote options
  candidate_vote.save!
  candidate_vote
end

Factory.define :candidate_vote do |candidate_vote|
  candidate_vote.association  :candidate
  candidate_vote.voted        false
end
