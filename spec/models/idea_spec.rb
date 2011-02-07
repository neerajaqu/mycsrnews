require 'spec_helper'

describe Idea do
  it "should create a new instance given valid attributes" do
    Factory.create(:idea)
  end
end
