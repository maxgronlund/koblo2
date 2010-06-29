Given /^a user called "([^"]*)"$/ do |name|
  @password = 'very_secret'
  User.make(:name => name, :password => @password)
end

Given /^I am logged in as "([^"]*)"$/ do |name|
  user = User.where(:name => name).first
  And %{I go to login}
  And %{I fill in "user_email" with "#{user.email}"}
  And %{I fill in "user_password" with "#{@password}"}
  And %{I press "Sign in"}
end

Given /^"([^"]*)" is following "([^"]*)"$/ do |follower_name, followable_name|
  follower = User.where(:name => follower_name).first
  followable = User.where(:name => followable_name).first
  follower.follow(followable)
end


Given /^I am looking at the profile page for "([^"]*)"$/ do |name|
  user = User.where(:name => name).first
  visit user_path(user)
end

