# require File.dirname(__FILE__) + '/../../lib/cucover'
require 'spec'
require 'test/unit/assertions'

module CucoverHelper  
  def edit(file)
    original_mtime = File.mtime(file) 
    FileUtils.touch(file)
    @edited_files ||= {}
    @edited_files[file] = original_mtime
  end
  
  def restore_file_mtimes
    return unless @edited_files
    @edited_files.each do |file, original_mtime|
      `touch -t #{original_mtime.strftime('%Y%m%d%H%M.%S')} #{examples_dir}/#{file}`
    end
  end
  
  def strip_duration(s)
    s.gsub(/^\d+m\d+\.\d+s\n/m, "")
  end
  
  def clear_cache!
    `find examples -name cucover.data | xargs rm -rf`
  end
  
  def example_app
    @example_app || raise("Please call the step 'Given I am using the .... example app' so I know which example app to run these features in.")
  end

  def within_examples_dir
    Dir.chdir(examples_dir) do
      yield
    end
  end
  
  def examples_dir
    File.expand_path(File.dirname(__FILE__) + "/../../examples/self_test/#{example_app}")    
  end
end

World CucoverHelper, Test::Unit::Assertions

After do
  clear_cache!
  restore_file_mtimes
end