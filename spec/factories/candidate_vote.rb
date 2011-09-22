require 'spec/factories/ballot'

Factory.define :candidate_vote do |candidate_vote|
  candidate_vote.association  :candidate
  candidate_vote.voted        false
end
