class CandidateVote < ActiveRecord::Base
  belongs_to :office_vote
  belongs_to :candidate
  
  def name
    candidate && candidate.name
  end
  
  def vote
    self.voted = true
  end
  
  def tampered?(office)
    !candidate || candidate.office != office
  end
  
end
