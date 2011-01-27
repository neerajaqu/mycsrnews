require 'spec_helper'

describe Feed do
  it "should create a new instance given valid attributes" do
    Factory.create(:feed)
  end
end
