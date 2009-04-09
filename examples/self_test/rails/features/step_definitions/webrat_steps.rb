When /^I go to (.+)$/ do |path|
  visit path
end

Then /^I should see "([^\"]*)"$/ do |text|
  response.should contain(text)
end
