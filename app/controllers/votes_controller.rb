class VotesController < ApplicationController

  before_filter :find_ballot
  before_filter :find_page

  def create
    @ballot_vote = BallotVote.new params[:ballot_vote]
    @ballot_vote.ballot = @ballot
    if @ballot_vote.save
      present @page
    else
      render :new
    end
  end

  def new
    @ballot_vote = BallotVote.new_for_ballot @ballot
    present(@page)
  end
    
protected

  def find_ballot
    @ballot = Ballot.where(:id => params[:ballot_id]).first
  end

  def find_page
    @page = Page.where(:link_url => "/ballots").first
  end

end
