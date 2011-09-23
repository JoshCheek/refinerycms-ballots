# injects functionality to member, but b/c of Rails lazy-loading we must
# force it to be loaded by referenceing it.
# 
# I'm willing to entertain the idea that this is not a good approach, and willing to hear alternatives
# At the same time, I don't completely hate it, except for the confusion in situations like this one.
BallotVote


class VotesController < ApplicationController

  before_filter :find_ballot
  before_filter :find_page

  def create
    @member = Member.find_by_unique_identifier params[:unique_identifier]
    @ballot_vote = BallotVote.new params[:ballot_vote]
    @ballot_vote.ballot = @ballot
    @ballot_vote.member = @member
    if does_create?
      flash[:notice] = "Thank you for voting."
      render :new
    else
      flash[:error] = "It appears there was a problem, please try again."
      redirect_to login_ballot_votes_path(@ballot)
    end
  end

  def login
    present @page
  end

  def new
    @member = Member.find_by_unique_identifier params[:unique_identifier]
    if !@member
      flash[:error] = 'Please double check your number and try again. If it is correct, you may need to contact an admin.'
      redirect_to login_ballot_votes_path(@ballot)
    elsif @member.has_voted_on?(@ballot)
      flash[:error] = "You have already voted on this ballot, revoting isn't allowed"
      redirect_to login_ballot_votes_path(@ballot)
    else
      @ballot_vote = BallotVote.new_for_ballot @ballot
    end
  end
    
protected

  def find_ballot
    @ballot = Ballot.where(:id => params[:ballot_id]).first
  end

  def find_page
    @page = Page.where(:link_url => "/ballots").first
  end
  
  def does_create?
    no_member? || cant_save? || was_tampered_with?
  end
  
  def cant_save?
    !@ballot_vote.save
  end
  
  def no_member?
    !@member
  end
  
  def was_tampered_with?
    @ballot_vote.tampered?
  end
end
