class VotesController < ApplicationController

  before_filter :find_ballot
  before_filter :find_page

  def create
    present(@page)
  end

  def new
    @vote = voting_for @ballot
    present(@page)
  end
  
protected

  def voting_for(ballot)
    raise 'Implement me!'
  end

  def find_ballot
    @ballot = Ballot.where(:id => params[:ballot_id]).first
  end

  def find_page
    @page = Page.where(:link_url => "/ballots").first
  end

end
