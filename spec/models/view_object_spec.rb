require 'spec_helper'

describe ViewObject do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    ViewObject.create!(@valid_attributes)
  end
end
