 class BallotsController < ApplicationController

  before_filter :find_all_ballots
  before_filter :find_page

  def index
    redirect_to root_url
  end

  def show
    @ballot = Ballot.find(params[:id])

    # you can use meta fields from your model instead (e.g. browser_title)
    # by swapping @page for @ballot in the line below:
    present(@page)
  end

protected

  def find_all_ballots
    @ballots = Ballot.order('position ASC')
  end

  def find_page
    @page = Page.where(:link_url => "/ballots").first
  end

end
