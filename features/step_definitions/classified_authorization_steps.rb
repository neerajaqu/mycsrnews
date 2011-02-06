Given /^a (.+) classifed user exists$/ do |user_status|
  case user_status
  when "owner"
    @user = model('user')
    mock(@user).friends_of_friends_with? { true }
    mock(@user).friends_with? { true }
  when "generic"
    @user = Factory.build(:user)
    mock(@user).friends_of_friends_with?(is_a(User)) { false }
    mock(@user).friends_with?(is_a(User)) { false }
  when "friend"
    @user = Factory.build(:user)
    mock(@user).friends_of_friends_with?(is_a(User)) { true }
    mock(@user).friends_with?(is_a(User)) { true }
  when "friend_of_friend"
    @user = Factory.build(:user)
    mock(@user).friends_of_friends_with?(is_a(User)) { true }
    mock(@user).friends_with?(is_a(User)) { false }
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
