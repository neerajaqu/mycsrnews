require 'spec_helper'

describe Card do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    Card.create!(@valid_attributes)
  end
end
