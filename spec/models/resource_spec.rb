require 'spec_helper'

describe Resource do
  it "should create a new instance given valid attributes" do
    Factory.create(:resource)
  end
end
