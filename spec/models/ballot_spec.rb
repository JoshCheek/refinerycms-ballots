require 'spec_helper'

describe Ballot do

  def reset_ballot(options = {})
    @valid_attributes = {
      :id => 1,
      :title => "RSpec is great for testing too"
    }

    @ballot.destroy! if @ballot
    @ballot = Ballot.create!(@valid_attributes.update(options))
  end

  before(:each) do
    reset_ballot
  end

  context "validations" do
    
    it "rejects empty title" do
      Ballot.new(@valid_attributes.merge(:title => "")).should_not be_valid
    end

    it "rejects non unique title" do
      # as one gets created before each spec by reset_ballot
      Ballot.new(@valid_attributes).should_not be_valid
    end
    
  end

end