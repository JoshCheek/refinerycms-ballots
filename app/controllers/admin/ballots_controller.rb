module Admin
  class BallotsController < Admin::BaseController

    crudify :ballot, :xhr_paging => true

  end
end


