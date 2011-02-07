require 'spec_helper'

describe Topic do
  it "should create a new instance given valid attributes" do
    pending "need to migrate logic from topics controller into topic model"
    topic = Factory.create(:topic)
    topic.posts.should_not be_empty
  end

  it "should create the associated posts (need to migrate logic from topics controller into topic model)"
  it "should appropriately call comments_callback"
  it "should set valid crumb parents"
  it "should set a valid crumb link"

  describe "#details" do
    before(:each) do
      @topic = Factory.create(:topic)
      2.times { @topic.posts.push Factory.create(:comment, :commentable => @topic) }
    end

    it "should set a valid item description" do
      @topic.item_description.should == @topic.posts.first.comments
    end

    it "should have a valid last post" do
      @topic.last_post.should == @topic.posts.last
    end

    it "should set valid voices count" do
      pending("Fix topic posts create")
      @topic.voices_count.should == 3
    end
  end

end
