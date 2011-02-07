require 'spec_helper'

describe Newswire do
  it "should create a new instance given valid attributes" do
    Factory.create(:newswire)
  end
end
