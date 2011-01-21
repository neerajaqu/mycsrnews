require 'spec_helper'

describe Topic do
  it "should create a new instance given valid attributes" do
    Factory.create(:topic)
  end

end
