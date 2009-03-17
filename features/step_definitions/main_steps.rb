def within_examples_dir
  full_dir = File.expand_path(File.dirname(__FILE__) + "/../../examples/self_test")
  Dir.chdir(full_dir) do
    yield
  end
end

Given /^I have run cucover (.*)$/ do |args|
  When %{I run cucover "#{args}"}
end

Given /^the cache is clear$/ do
  `find examples -name .coverage | xargs rm -rf`
end

When /^I run cucover (.*)$/ do |args|
  cucover_binary = File.expand_path(File.dirname(__FILE__) + '../../../bin/cucover')
  within_examples_dir do
    full_cmd = "#{Cucumber::RUBY_BINARY} #{cucover_binary} #{args}"
    @out = `#{full_cmd}`
    @status = $?.exitstatus
  end
end

When /^I edit the source file (.*)$/ do |source_file|
  within_examples_dir do
    FileUtils.touch(source_file)
  end
end

Then /^it should (pass|fail) with:$/ do |expected_status, expected_text|
  expected_status_code = expected_status == "pass" ? 0 : 1
  
  unless @status == expected_status_code
    raise "Expected #{expected_status} but return code was #{@status}: #{@out}"
  end
  
  @out.should == expected_text
end