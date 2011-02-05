Given /^a (.+) classifed user exists$/ do |user_status|
  case user_status
  when "owner"
    @user = model('user')
    @user.stub(:friends_of_friends_with?).and_return true
    @user.stub(:friends_with?).and_return true
    @user.should_not_receive(:friends_with?)
    @user.should_not_receive(:friends_of_friends_with?)
  when "generic"
    @user = Factory(:user)
    @user.stub(:friends_of_friends_with?).and_return false
    @user.stub(:friends_with?).and_return false
  when "friend"
    @user = Factory(:user)
    @user.stub(:friends_of_friends_with?).and_return true
    @user.stub(:friends_with?).and_return true
  when "friend_of_friend"
    @user = Factory(:user)
    #@user.should_receive(:friends_with?).and_return(false)
    #@user.stub :friends_of_friends_with?, true
    @user.stub(:friends_of_friends_with?).and_return true
    @user.stub(:friends_with?).and_return false
    #@user.should_receive(:friends_of_friends_with?)
  when "anonymous"
    @user = nil
  else
  	raise "Unknown user status:: #{user_status}"
  end
end

Then /^the user is_allowed\? should return "([^\"]*)"$/ do |return_val|
  classified = model('classified')
  classified.is_allowed?(@user).to_s.should == return_val
end
