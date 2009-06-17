# require File.dirname(__FILE__) + '/../../lib/cucover'
require 'spec'

module CucoverHelper
  def clear_cache!
    `find examples -name cucover.data | xargs rm -rf`
  end
  
  def example_app
    @example_app || raise("Please call the step 'Given I am using the .... example app' so I know which example app to run these features in.")
  end

  def within_examples_dir
    full_dir = File.expand_path(File.dirname(__FILE__) + "/../../examples/self_test/#{example_app}")
    Dir.chdir(full_dir) do
      yield
    end
  end
end

World CucoverHelper

After do
  clear_cache!
end