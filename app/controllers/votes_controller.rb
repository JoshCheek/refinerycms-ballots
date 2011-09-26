# injects functionality to member, but b/c of Rails lazy-loading we must
# force it to be loaded by referenceing it.
# 
# I'm willing to entertain the idea that this is not a good approach, and willing to hear alternatives
# At the same time, I don't completely hate it, except for the confusion in situations like this one.
BallotVote


class VotesController < ApplicationController

  before_filter :find_ballot
  before_filter :find_page
  before_filter :find_member, :except => :login
  
  def login
    if @ballot.too_early_to_vote?
      flash[:error] = "This election doesn't start until #{@ballot.pretty_start_date}"
      redirect_to root_url
    elsif @ballot.too_late_to_vote?
      flash[:error] = "This election ended on #{@ballot.pretty_end_date}"
      redirect_to root_url
    else
      present @page
    end
  end

  # this is basically a state machine to take you through the form
  def proceed
    case params[:commit]
    when /proceed/i  then new                 # login   -> new
    when /vote/i     then confirm             # new     -> confirm
    when /back/i     then back_to_new         # confirm -> new
    when /confirm/i  then create              # confirm -> create
    else
      logger.error "VotesController#proceed was called with params[:commit]=#{params[:commit].inspect}"
      unspecified_error
    end
  end

  
    
protected

  def new
    if !@member
      flash[:error] = 'Please double check your number and try again. If it is correct, you may need to contact an admin.'
      redirect_to login_ballot_votes_path(@ballot)
    elsif @member.has_voted_on?(@ballot)
      flash[:error] = "You have already voted on this ballot, revoting isn't allowed"
      redirect_to login_ballot_votes_path(@ballot)
    else
      @ballot_vote = BallotVote.new_for_ballot @ballot
      render :new
    end
  end

  def confirm
    find_ballot_vote
    if cannot_create_ballot_vote?
      log_cant_create_ballot('new->confirm')
      unspecified_error
    elsif @ballot_vote.valid?
      render :confirm
    else
      render :new
    end
  end
    
  def back_to_new
    find_ballot_vote
    render :new
  end

  def create
    find_ballot_vote
    if can_create_ballot_vote? && @ballot_vote.save
      flash[:notice] = "Thank you for voting."
      redirect_to root_url
    else
      log_cant_create_ballot('confirm->create')
      unspecified_error
    end
  end
  
  def unspecified_error
    flash[:error] = "It appears there was a problem, please try again."
    redirect_to login_ballot_votes_path(@ballot)
  end

  def find_ballot
    @ballot = Ballot.where(:id => params[:ballot_id]).first
  end

  def find_page
    @page = Page.where(:link_url => "/ballots").first
  end
  
  def find_member
    @member = Member.find_by_unique_identifier params[:unique_identifier]
  end
  
  def find_ballot_vote
    @ballot_vote = BallotVote.new params[:ballot_vote]
    @ballot_vote.ballot = @ballot
    @ballot_vote.member = @member
  end
  
  def cannot_create_ballot_vote?
    !can_create_ballot_vote?
  end
  
  def can_create_ballot_vote?
    @member && !@ballot_vote.tampered?
  end

  def log_cant_create_ballot(path_through_state_machine='')
    logger.error "Ballots #{path_through_state_machine} failed @member=#{@member.inspect}"
    logger.error "Ballots #{path_through_state_machine} failed @ballot_vote.tampered?=#{@ballot_vote.tampered?.inspect}"
    logger.error "Ballots #{path_through_state_machine} failed @ballot_vote.errors=#{@ballot_vote.errors.inspect}"
  end
  
end
