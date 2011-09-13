require 'spec_helper'

describe Campaign do

  def reset_campaign(options = {})
    @valid_attributes = {
      :id => 1,
      :title => "RSpec is great for testing too"
    }

    @campaign.destroy! if @campaign
    @campaign = Campaign.create!(@valid_attributes.update(options))
  end

  before(:each) do
    reset_campaign
  end

  context "validations" do
    
    it "rejects empty title" do
      Campaign.new(@valid_attributes.merge(:title => "")).should_not be_valid
    end

    it "rejects non unique title" do
      # as one gets created before each spec by reset_campaign
      Campaign.new(@valid_attributes).should_not be_valid
    end
    
  end

end