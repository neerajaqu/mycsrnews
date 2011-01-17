=begin
Given /^I am a logged in user$/ do
  @user = Factory.create(:user, :login => "bobbarker", :password => "asdfasdf")
  visit new_session_path
  fill_in "login", :with => "bobbarker"
  fill_in "password", :with => "asdfasdf"
  click_button 'login-button'
  Then "I should be on the home_index page"
end
=end

And /^I should see the widget user bio$/ do
  page.has_selector?(".thumb.user-bio").should be_true
end

And /^I have created a (.+?)(?: with (.*))?$/ do |klass, with|
  with = with ? ", #{with}" : ""
  #Given "a #{klass} exists with user_id: \"#{@user.id}\"#{with}"
  create_model!(klass, %{user_id: "#{@user.id}"#{with}})
end

Given /^a user is logged in$/ do
  user = create_model("user")
  visit new_session_path
  login_with_credentials(user.login, user.password)
end

Given /^I am logged in$/ do
  Given "a user is logged in"
end

When /^I login as #{capture_model}$/ do |login|
  user = created_model!(login)
  visit new_session_path
  login_with_credentials(user.login, user.password)
end

module LoginHelpers
  def login_with_credentials(login, password)
    fill_in "login", :with => login
    fill_in "password", :with => password
    click_button "login-button"
  end
end
World(LoginHelpers)
