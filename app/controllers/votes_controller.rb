class VotesController < ApplicationController

  before_filter :find_ballot
  before_filter :find_page

  def create
    present(@page)
  end

  def new
    @ballot_vote = ballot_vote_for @ballot
    present(@page)
  end
  
protected

  def ballot_vote_for(ballot)
    bv = BallotVote.new :ballot => ballot
    ballot.offices.each do |office|
      ov = bv.office_votes.build :office => office
      office.candidates.each do |candidate|
        ov.candidate_votes.build :candidate => candidate
      end
    end
    bv
  end

  def find_ballot
    @ballot = Ballot.where(:id => params[:ballot_id]).first
  end

  def find_page
    @page = Page.where(:link_url => "/ballots").first
  end

end
