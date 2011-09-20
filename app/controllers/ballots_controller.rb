 class BallotsController < ApplicationController

  before_filter :find_all_ballots
  before_filter :find_page

  def index
    redirect_to root_url
  end

  def show
    redirect_to root_url
  end

protected

  def find_all_ballots
    @ballots = Ballot.order('position ASC')
  end

  def find_page
    @page = Page.where(:link_url => "/ballots").first
  end

end
