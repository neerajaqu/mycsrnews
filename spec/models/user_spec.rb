require 'spec_helper'

describe User do
  it "should create a new instance given valid attributes" do
    Factory.create(:user)
  end

  context "#when there is a valid user" do
    before(:each) do
      @password = 'foobar'
      @fb_user_id = 1234567890
      @user = Factory(:user, :password => @password, :password_confirmation => @password, :fb_user_id => @fb_user_id)
    end

    it "should have a valid user profile" do
      @user.profile.should_not be_nil
    end

    it "should be a facebook user" do
      @user.facebook_user?.should be_true
    end

    it "should not be a connect facebook user" do
      @user.facebook_connect_user?.should be_false
    end

    it "should not be an admin" do
      @user.is_admin?.should be_false
    end

    it "should not be an editor" do
      @user.is_editor?.should be_false
    end

    it "should not be a moderator" do
      @user.is_moderator?.should be_false
    end

    it "should not be an host" do
      @user.is_host?.should be_false
    end

    it "should not be established" do
      @user.is_established?.should be_false
    end

    it "should not have a bio by default" do
      @user.bio.should be_nil
    end

    it "should return the user name for to_s" do
      @user.to_s.should == @user.name
    end

    it "should be able to authenticate" do
      User.authenticate(@user.login, @password).should == @user
    end

    it "should be able to find the user by facebook id" do
      User.find_by_fb_user_id(@user.fb_user_id).should == @user
    end

    describe "#facebook user id" do
      it "should return the appropriate facebook user id" do
        @user.fb_user_id.should == @fb_user_id
      end

      it "should return the appropriate facebook user id from user profile" do
        @user.update_attribute(:fb_user_id, nil)
        @user.profile.update_attribute(:facebook_user_id, 223334444)
        @user.fb_user_id.should == 223334444
      end

      it "should return nil when not a facebook user" do
        @user.update_attribute(:fb_user_id, nil)
        @user.fb_user_id.should be_nil
      end
    end

    it "should accept email notifications by default" do
      @user.accepts_email_notifications?.should be_true
    end

    it "should have a combined score of zero to start" do
      @user.combined_score.should == 0
    end

    it "should not be a blogger by default" do
      @user.is_blogger?.should be_false
    end

    it "should not have any friends by default" do
      @user.friends.any?.should be_false
    end

    describe "#facebook oauth" do
      it "should not be active with facebook oauth by default" do
        @user.fb_oauth_active?.should be_false
      end

      it "should be allowed to request oauth access" do
        @user.fb_oauth_desired?.should be_true
      end
    end

    describe "#public name" do
      before(:each) do
        @first = "Robert"
        @last = "Hoag"
        @name = @first + " " + @last
        @user.update_attribute(:name, @name)
      end

      it "should return the full name by default" do
        @user.public_name.should == @name
      end

      it "should return the first name when first name only is configured" do
        get_setting('firstnameonly').try(:value) = true
        @user.public_name.should == @first
      end
    end
  end
end
