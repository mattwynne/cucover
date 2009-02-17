When /^I run cucover features$/ do
  full_dir = File.expand_path(File.dirname(__FILE__) + "/../../examples/self_test")
  Dir.chdir(full_dir) do
    full_cmd = "#{Cucover::RUBY_BINARY} #{Cucover::BINARY} features"
    @out = `#{full_cmd}`
    @status = $?.exitstatus
  end
end

Then /^it should pass with$/ do |expected_text|
  @status.should == 0
  @out.should == expected_text
end