require 'rubygems'

gem 'cucumber', '>=0.3.1'
require 'cucumber'

gem 'spicycode-rcov', '>=0.8.1.5.0'
require 'rcov'
require 'spec'

$:.unshift(File.dirname(__FILE__)) 
require 'cucover/monkey'
require 'cucover/rails'

module Cucover
  class TestIdentifier < Struct.new(:file, :line)
    def initialize(file_colon_line)
      file, line = file_colon_line.split(':')
      super(file, line)
      self.freeze
    end
    
    def to_s
      "#{file}:#{line.to_s}"
    end
  end
  
  class CoverageRecording
    def initialize(test_identifier)
      @analyzer = Rcov::CodeCoverageAnalyzer.new        
      @cache = SourceFileCache.new(test_identifier)
      @covered_files = []
    end
    
    def record_file(source_file)
      @covered_files << source_file unless @covered_files.include?(source_file)
    end
    
    def record_coverage
      @analyzer.run_hooked do
        yield
      end
      @covered_files.concat @analyzer.analyzed_files
    end
    
    def save
      @cache.save filter(normalized_files)
    end
    
    private
    
    def filter(files)
      files.reject!{ |f| boring?(f) }
    end
    
    def boring?(file)
      (file.match /gem/) || (file.match /vendor/) || (file.match /lib\/ruby/)
    end
    
    def normalized_files
      @covered_files.map{ |f| File.expand_path(f).gsub(/^#{Dir.pwd}\//, '') }
    end
  end
  
  class Executor
    def initialize(test_identifier)
      @source_files_cache = SourceFileCache.new(test_identifier)      
      @status_cache       = StatusCache.new(test_identifier)
    end
    
    def should_execute?
      dirty? || failed_on_last_run?
    end
    
    private
    
    def failed_on_last_run?
      return false unless @status_cache.exists?
      @status_cache.last_run_status == "failed"
    end
    
    def dirty?
      return true unless @source_files_cache.exists?
      @source_files_cache.any_dirty_files?
    end
  end
  
  class TestRun
    def initialize(test_identifier, visitor)
      @test_identifier, @visitor = test_identifier, visitor
      @coverage_recording = CoverageRecording.new(test_identifier)
      @status_cache       = StatusCache.new(test_identifier)
    end
    
    def record(source_file)
      @coverage_recording.record_file(source_file)
    end
    
    def fail!
      @failed = true
    end
    
    def watch(&block)
      record(@test_identifier.file)
      @coverage_recording.record_coverage(&block)
      @coverage_recording.save
      
      @status_cache.record(status)
    end
    
    private
    
    def status
      @failed ? :failed : :passed
    end
  end
  
  class << self
    def start_test(test_identifier, visitor, &block)
      @current_test = TestRun.new(test_identifier, visitor)
      @current_test.watch(&block)
    end
    
    def fail_current_test!
      current_test.fail!
    end
    
    def record(source_file)
      current_test.record(source_file)
    end
    
    def can_skip?
      not current_test.should_execute?
    end
    
    private
    
    def current_test
      @current_test or raise("You need to start a test first, with a call to #start_test")
    end
  end
  
  class Cache
    def initialize(test_identifier)
      @test_identifier = test_identifier
    end
    
    def exists?
      File.exist?(cache_file)
    end
    
    private
    
    def cache_file
      cache_folder + '/' + cache_filename
    end
    
    def cache_folder
      @test_identifier.file.gsub(/([^\/]*\.feature)/, ".coverage/\\1/#{@test_identifier.line.to_s}")
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
    
    private
    
    def cache_filename
      'covered_source_files'
    end

    def source_files
      cache_content
    end

    def dirty_files
      source_files.select do |source_file|
        !File.exist?(source_file.strip) or (File.mtime(source_file.strip) >= time)
      end
    end
  end

  module RecordsFailures
    def failed(exception, clear_backtrace)
      Cucover.fail_current_test!
      super
    end
  end
  
  class Controller
    class << self
      def [](scenario)
        new(TestIdentifier.new(scenario.file_colon_line))
      end
    end
    
    def initialize(test_id)
      @test_id  = test_id
      @executor = Executor.new(test_id)
    end
    
    def should_skip?
      yield if (block_given? and !should_execute?)
      return !should_execute?
    end
    
    def should_execute?
      result = @executor.should_execute?      
      yield if block_given? and result
      result
    end
  end

  module RecordsCoverage
    def accept(visitor)
      Cucover.start_test(TestIdentifier.new(file_colon_line), visitor) do
        super
      end
    end
  end
  
  module ScenarioExtensions
    module SkipsStableTests    
      def accept(visitor)
        if should_skip?
          skip_invoke!
          visitor.announce "[ Cucover - Skipping clean scenario ]"
        end
        super
      end
      
      def should_skip?
        Cucover::Controller[self].should_skip? and (!@background or Cucover::Controller[@background].should_skip?)
      end
    end

    include SkipsStableTests
    include RecordsCoverage
  end
  
  module FeatureExtensions
    def should_skip?
      @feature_elements.all?{ |e| Cucover::Controller[e].should_skip? }
    end
  end
  
  module BackgroundExtensions
    module SkipsStableTests
      def accept(visitor)
        if (@feature.should_skip? and Cucover::Controller[self].should_skip?)
          skip_invoke!
          visitor.announce "[ Cucover - Skipping background for clean feature ]"
        end
        super
      end
      
      def skip_invoke!
        @step_invocations.each{ |i| i.skip_invoke! }        
      end
    end

    include RecordsCoverage
    include SkipsStableTests
  end
  
end

Cucover::Monkey.extend_every Cucumber::Ast::Feature        => Cucover::FeatureExtensions
Cucover::Monkey.extend_every Cucumber::Ast::Scenario       => Cucover::ScenarioExtensions
Cucover::Monkey.extend_every Cucumber::Ast::Background     => Cucover::BackgroundExtensions
Cucover::Monkey.extend_every Cucumber::Ast::StepInvocation => Cucover::RecordsFailures

Before do
  Cucover::Rails.patch_if_necessary
end
