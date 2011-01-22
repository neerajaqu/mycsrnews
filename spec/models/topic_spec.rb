require 'spec_helper'

describe Topic do
  it "should create a new instance given valid attributes" do
    pending "need to migrate logic from topics controller into topic model"
    topic = Factory.create(:topic)
    topic.posts.should_not be_empty
  end

  it "should create the associated posts (need to migrate logic from topics controller into topic model)"

end
