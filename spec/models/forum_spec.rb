require 'spec_helper'

describe Forum do
  it "should create a new instance given valid attributes" do
    Factory.create(:forum)
  end

end
