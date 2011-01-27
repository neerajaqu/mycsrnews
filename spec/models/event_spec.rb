require 'spec_helper'

describe Event do
  it "should create a new instance given valid attributes" do
    Factory.create(:event)
  end

  it "should validate start and end time"
end
