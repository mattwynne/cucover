require File.dirname(__FILE__) + '/../../lib/bar'
require File.dirname(__FILE__) + '/../../lib/foo'

When /^I call Foo$/ do
  Foo.new.execute
end

When /^I call Bar$/ do
  Bar.new.execute
end

When /^I divide by zero$/ do
  1/0
end