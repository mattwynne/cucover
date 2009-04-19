require File.dirname(__FILE__) + '/../../lib/foo'
require File.dirname(__FILE__) + '/../../lib/bar'
require File.dirname(__FILE__) + '/../../lib/baz'

Given /^I have called ([\w]+)$/ do |class_name|
  Object.const_get(class_name).new.execute
end

When /^I call ([\w]+)$/ do |class_name|
  Given "I have called #{class_name}"
end

When /^I divide by zero$/ do
  1/0
end