
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
  
  class TestExecution
    def record(source_file)
      additional_covered_files << source_file
    end
    
    def additional_covered_files
      @additional_covered_files ||= []
    end
    
    def fail!
      @failed = true
    end
    
    def status
      @failed ? :failed : :passed
    end
    
    def initialize(feature_file)
      @feature_file = feature_file
    end
    
    def may_execute?
      dirty? || failed_on_last_run?
    end
    
    def watch(visitor)
      analyzer.run_hooked do
        yield
      end
      
      source_files_cache.save analyzed_files
      status_cache.record(status)
    end
    
    private
    
    def failed_on_last_run?
      return false unless status_cache.exists?
      status_cache.last_run_status == "failed"
    end
    
    def dirty?
      return true unless source_files_cache.exists?
      return true if feature_file_changed_since_last_run?
      source_files_cache.any_dirty_files?
    end
    
    def feature_file_changed_since_last_run?
      File.mtime(@feature_file) >= source_files_cache.time
    end

    def source_files_cache
      @source_files_cache ||= SourceFileCache.new(@feature_file)
    end
    
    def status_cache
      @status_cache ||= StatusCache.new(@feature_file)
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
      (file.match /gem/) || (file.match /vendor/) || (file.match /lib\/ruby/)
    end
    
    def analyzer
      @analyzer ||= Rcov::CodeCoverageAnalyzer.new      
    end
    
  end
  
  class << self
    def start_test(test, visitor) 
      @current_test = TestExecution.new(test.file)
      return if should_skip?

      @current_test.watch(visitor) do
        yield
      end
    end
    
    def fail_current_test!
      current_test.fail!
    end
    
    def record(source_file)
      current_test.record(source_file)
    end
    
    def should_skip?
      not current_test.may_execute?
    end
    
    private
    
    def current_test
      @current_test or raise("You need to start the a test first!")
    end
  end
  
  class Cache
    def initialize(feature_file)
      @feature_file = feature_file
    end    
    
    def exists?
      File.exist?(cache_filename)
    end
    
    def cache_filename
      @feature_file.gsub /([^\/]*\.feature)/, '.coverage/\1'
    end
    
    def time
      File.mtime(cache_filename)
    end

    def write_to_cache
      FileUtils.mkdir_p File.dirname(cache_filename)
      File.open(cache_filename, "w") do |file|
        yield file
      end
    end
  end
  
  class StatusCache < Cache
    def last_run_status
      File.open(cache_filename, "r") do |file|
        file.each_line do |line|
          return line.strip
        end
      end
    end
    
    def record(status)
      write_to_cache do |file|
        file.puts status
      end
    end
    
    private

    def cache_filename
      super + '.status'
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
    
    private

    def dirty_files
      source_files.select do |source_file|
        File.mtime(source_file.strip) >= time
      end
    end
    
    def source_files
      result = []
      File.open(cache_filename, "r") do |file|
        file.each_line do |line|
          result.push line
        end
      end
      result
    end
  end
  
  module LazyStepInvocation
    def accept(visitor)
      skip_invoke! if Cucover.should_skip?
      super
    end
    
    def failed(exception, clear_backtrace)
      Cucover.fail_current_test!
      super
    end
  end
  
  module LazyFeature
    def accept(visitor)
      Cucover.start_test(self, visitor) do
        super
      end
    end
    
  end
end

Cucover::Monkey.extend_every Cucumber::Ast::Feature => Cucover::LazyFeature
Cucover::Monkey.extend_every Cucumber::Ast::StepInvocation => Cucover::LazyStepInvocation

Before do
  Cucover::Rails.patch_if_necessary
end