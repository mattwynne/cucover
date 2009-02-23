When /^I run cucover (.*)$/ do |args|
  full_dir = File.expand_path(File.dirname(__FILE__) + "/../../examples/self_test")
  Dir.chdir(full_dir) do
    full_cmd = "#{Cucover::RUBY_BINARY} #{Cucover::BINARY} #{args}"
    @out = `#{full_cmd}`
    @status = $?.exitstatus
  end
end

Then /^it should (pass|fail) with$/ do |expected_status, expected_text|
  expected_status_code = expected_status == "pass" ? 0 : 1
  
  unless @status == expected_status_code
    raise "Expected #{expected_status} but return code was #{@status}: #{@out}"
  end
  
  @out.should == expected_text
end