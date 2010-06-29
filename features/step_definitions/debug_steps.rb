Given /^I print$/ do
  puts response.inspect
end

Given /^I debug$/ do
  puts Follow.all.inspect
  puts Song.all.inspect
  puts Activity.all.inspect 
end

