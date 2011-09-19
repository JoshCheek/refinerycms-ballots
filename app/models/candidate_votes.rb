class CandidateVote < ActiveRecord::Base
  belongs_to :office_vote
  belongs_to :candidate
end
