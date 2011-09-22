class VotesController < ApplicationController

  before_filter :find_ballot
  before_filter :find_page

  def create
    @member = Member.find_by_unique_identifier params[:unique_identifier]
    @ballot_vote = BallotVote.new params[:ballot_vote]
    @ballot_vote.ballot = @ballot
    @ballot_vote.member = @member
    save = !@ballot_vote.save
    member = !@member
    tampered = @ballot_vote.tampered?

    if member || tampered || save # !@member || @ballot_vote.tampered? || !@ballot_vote.save
      render :new
    else
      redirect_to root_url
    end
  end

  def login
    present @page
  end

  def new
    @member = Member.find_by_unique_identifier params[:unique_identifier]
    if @member
      @ballot_vote = BallotVote.new_for_ballot @ballot
    else
      redirect_to login_ballot_votes_path(@ballot)
    end
  end
    
protected

  def find_ballot
    @ballot = Ballot.where(:id => params[:ballot_id]).first
  end

  def find_page
    @page = Page.where(:link_url => "/ballots").first
  end

end
