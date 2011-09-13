module Admin
  class CampaignsController < Admin::BaseController

    crudify :campaign, :xhr_paging => true

  end
end
