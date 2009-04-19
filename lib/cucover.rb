require 'rubygems'

gem 'cucumber', '>=0.3'
require 'cucumber'

gem 'spicycode-rcov', '>=0.8.1.5.0'
require 'rcov'
require 'spec'

$:.unshift(File.dirname(__FILE__)) 
require 'cucover/monkey'
require 'cucover/rails'

module Cucover  
  class TestRun
    def initialize(feature_file, line, visitor)
      @feature_file, @line, @visitor = feature_file, line, visitor
    end
    
    def record(source_file)
      additional_covered_files << source_file
    end
    
    def fail!
      @failed = true
    end
    
    def watch
      announce_skip unless may_execute?

      analyzer.run_hooked do
        yield
      end
      
      record(@feature_file)
      source_files_cache.save analyzed_files
      status_cache.record(status)
    end
    
    def may_execute?
      dirty? || failed_on_last_run?
    end
    
    private
    
    def status
      @failed ? :failed : :passed
    end
    
    def additional_covered_files
      @additional_covered_files ||= []
    end
    
    def announce_skip
      @visitor.announce "[ Cucover - Skipping clean scenario ]"
    end
    
    def failed_on_last_run?
      return false unless status_cache.exists?
      status_cache.last_run_status == "failed"
    end
    
    def dirty?
      return true unless source_files_cache.exists?
      source_files_cache.any_dirty_files?
    end
    
    def source_files_cache
      @source_files_cache ||= SourceFileCache.new(@feature_file, @line)
    end
    
    def status_cache
      @status_cache ||= StatusCache.new(@feature_file, @line)
    end
    
    def source_files
      analyzed_files
    end
    
    def analyzed_files
      normalized_files.reject{ |f| boring?(f) }.sort
    end
    
    def normalized_files
      (analyzer.analyzed_files + additional_covered_files.uniq).map{ |f| File.expand_path(f).gsub(/^#{Dir.pwd}\//, '') }
    end
    
    def boring?(file)
      return false
      # TODO: maybe use this code for presentation?
      # (file.match /gem/) || (file.match /vendor/) || (file.match /lib\/ruby/) 
    end
    
    def analyzer
      @analyzer ||= Rcov::CodeCoverageAnalyzer.new      
    end
  end
  
  class << self
    def start_test(test_file, line, visitor) 
      @current_test = TestRun.new(test_file, line, visitor)

      @current_test.watch do
        yield
      end
    end
    
    def fail_current_test!
      current_test.fail!
    end
    
    def record(source_file)
      current_test.record(source_file)
    end
    
    def can_skip?
      not current_test.may_execute?
    end
    
    private
    
    def current_test
      @current_test or raise("You need to start the a test first!")
    end
  end
  
  class Cache
    def initialize(feature_file, line)
      @feature_file, @line = feature_file, line
    end
    
    def exists?
      File.exist?(cache_file)
    end
    
    private
    
    def cache_file
      cache_folder + '/' + cache_filename
    end
    
    def cache_folder
      @feature_file.gsub(/([^\/]*\.feature)/, ".coverage/\\1/#{@line.to_s}")
    end
    
    def time
      File.mtime(cache_file)
    end

    def write_to_cache
      FileUtils.mkdir_p File.dirname(cache_file)
      File.open(cache_file, "w") do |file|
        yield file
      end
    end
    
    def cache_content
      File.readlines(cache_file)
    end
  end
  
  class StatusCache < Cache
    def last_run_status
      cache_content.to_s.strip
    end
    
    def record(status)
      write_to_cache do |file|
        file.puts status
      end
    end
    
    private

    def cache_filename
      'last_run_status'
    end
  end
  
  class SourceFileCache < Cache
    def save(analyzed_files)
      write_to_cache do |file|
        file.puts analyzed_files
      end
    end
    
    def any_dirty_files?
      not dirty_files.empty?
    end
    
    def source_files
      cache_content
    end

    private
    
    def cache_filename
      'covered_source_files'
    end

    def dirty_files
      source_files.select do |source_file|
        File.mtime(source_file.strip) >= time
      end
    end
  end
  
  module LazyStepInvocation
    def accept(visitor)
      skip_invoke! if Cucover.can_skip?
      super
    end
    
    def failed(exception, clear_backtrace)
      Cucover.fail_current_test!
      super
    end
  end
  
  module LazyTestCase
    def accept(visitor)
      Cucover.start_test(@feature.file, @line, visitor) do
        super
      end
    end
  end
  
end

Cucover::Monkey.extend_every Cucumber::Ast::Scenario       => Cucover::LazyTestCase
Cucover::Monkey.extend_every Cucumber::Ast::Background     => Cucover::LazyTestCase
Cucover::Monkey.extend_every Cucumber::Ast::StepInvocation => Cucover::LazyStepInvocation

Before do
  Cucover::Rails.patch_if_necessary
end
