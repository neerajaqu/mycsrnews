require 'spec_helper'

describe Content do
  it "should create a new instance given valid attributes" do
    Factory.create(:content)
  end

  it "should require a title" do
    content = Factory.build(:content, :title => nil)
    content.should_not be_valid
    content.errors.on(:title).should_not be_nil
    content.title = Faker::Company.catch_phrase
    content.should be_valid
  end

  it "should require a url" do
    content = Factory.build(:content, :url => nil)
    content.should_not be_valid
    content.errors.on(:url).should_not be_nil
    content.url = "http://#{Faker::Internet.domain_name}/foo.jpg"
    content.should be_valid
  end

  it "should require a user" do
    content = Factory.build(:content, :user => nil)
    content.should_not be_valid
    content.errors.on(:user_id).should_not be_nil
    content.user = Factory(:user)
    content.should be_valid
  end

  it "should require a caption" do
    content = Factory.build(:content, :caption => nil)
    content.should_not be_valid
    content.errors.on(:caption).should_not be_nil
    content.caption = Faker::Lorem.paragraph
    content.should be_valid
  end

  it "should set a valid tweet setting group" do
    Content.tweet_setting_group.should == 'stories'
  end

  describe "#details" do
    before(:each) do
      @content = Factory.create(:content)
    end

    it "should not set full_html by default" do
      @content.full_html?.should be_false
    end

    it "should set model_score_name to story" do
      @content.model_score_name.should == 'story'
    end

    it "should return the content user for scoreable user" do
      @content.scorable_user.should == @content.user
    end

    it "should set the appropriate hash for featured url" do
      expected = {
      	:controller => '/stories',
      	:action => 'show',
      	:id => @content
      }
      @content.featured_url.should == expected
    end

    it "should set to_s to the content title" do
      @content.to_s.should == @content.title
    end
  end
end
