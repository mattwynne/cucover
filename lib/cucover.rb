require 'rubygems'

gem 'cucumber', '>=0.3.1'
require 'cucumber'

gem 'spicycode-rcov', '>=0.8.1.5.0'
require 'rcov'
require 'spec'

require 'logging'

$:.unshift(File.dirname(__FILE__)) 
require 'cucover/commands/coverage_of'
require 'cucover/commands/cucumber'
require 'cucover/cli'
require 'cucover/logging_config'
require 'cucover/monkey'
require 'cucover/rails'
require 'cucover/recording'
require 'cucover/store'

# 
# module Cucover
#   class TestIdentifier < Struct.new(:file, :line)
#     def initialize(file_colon_line)
#       file, line = file_colon_line.split(':')
#       super(file, line)
#       self.freeze
#     end
#     
#     def to_s
#       "#{file}:#{line.to_s}"
#     end
#   end
#   
#   class Executor
#     def initialize(test_identifier)
#       @source_files_cache = SourceFileCache.new(test_identifier)      
#       @status_cache       = StatusCache.new(test_identifier)
#     end
#     
#     def should_execute?
#       dirty? || failed_on_last_run?
#     end
#     
#     private
#     
#     def failed_on_last_run?
#       return false unless @status_cache.exists?
#       @status_cache.last_run_status == "failed"
#     end
#     
#     def dirty?
#       return true unless @source_files_cache.exists?
#       @source_files_cache.any_dirty_files?
#     end
#   end
#   
#   class TestRun
#     def initialize(test_identifier, visitor)
#       @test_identifier, @visitor = test_identifier, visitor
#       @coverage_recording = CoverageRecording.new(test_identifier)
#       @status_cache       = StatusCache.new(test_identifier)
#     end
#     
#     def record(source_file)
#       @coverage_recording.record_file(source_file)
#     end
#     
#     def fail!
#       @failed = true
#     end
#     
#     def watch(&block)
#       record(@test_identifier.file)
#       @coverage_recording.record_coverage(&block)
#       @coverage_recording.save
#       
#       @status_cache.record(status)
#     end
#     
#     private
#     
#     def status
#       @failed ? :failed : :passed
#     end
#   end
#   
#   class << self
#     def start_test(test_identifier, visitor, &block)
#       @current_test = TestRun.new(test_identifier, visitor)
#       @current_test.watch(&block)
#     end
#     
#     def fail_current_test!
#       current_test.fail!
#     end
#     
#     def can_skip?
#       not current_test.should_execute?
#     end
#     
#     private
#     
#     def current_test
#       @current_test or raise("You need to start a test first, with a call to #start_test")
#     end
#   end
# 
#   module RecordsFailures
#     def failed(exception, clear_backtrace)
#       Cucover.fail_current_test!
#       super
#     end
#   end
#   
#   class Controller
#     class << self
#       def [](scenario)
#         new(TestIdentifier.new(scenario.file_colon_line))
#       end
#     end
#     
#     def initialize(test_id)
#       @test_id  = test_id
#       @executor = Executor.new(test_id)
#     end
#     
#     def should_skip?
#       yield if (block_given? and !should_execute?)
#       return !should_execute?
#     end
#     
#     def should_execute?
#       result = @executor.should_execute?      
#       yield if block_given? and result
#       result
#     end
#   end
# 
#   module RecordsCoverage
#     def accept(visitor)
#       Cucover.start_test(TestIdentifier.new(file_colon_line), visitor) do
#         super
#       end
#     end
#   end
#   
#   module ScenarioExtensions
#     module SkipsStableTests    
#       def accept(visitor)
#         if should_skip?
#           skip_invoke!
#           visitor.announce "[ Cucover - Skipping clean scenario ]"
#         end
#         super
#       end
#       
#       def should_skip?
#         Cucover::Controller[self].should_skip? and (!@background or Cucover::Controller[@background].should_skip?)
#       end
#     end
# 
#     include SkipsStableTests
#     include RecordsCoverage
#   end
#   
#   module FeatureExtensions
#     def should_skip?
#       @feature_elements.all?{ |e| Cucover::Controller[e].should_skip? }
#     end
#   end
#   
#   module BackgroundExtensions
#     module SkipsStableTests
#       def accept(visitor)
#         if (@feature.should_skip? and Cucover::Controller[self].should_skip?)
#           skip_invoke!
#           visitor.announce "[ Cucover - Skipping background for clean feature ]"
#         end
#         super
#       end
#       
#       def skip_invoke!
#         @step_invocations.each{ |i| i.skip_invoke! }        
#       end
#     end
# 
#     include RecordsCoverage
#     include SkipsStableTests
#   end
#   
# end
# 
# Cucover::Monkey.extend_every Cucumber::Ast::Feature        => Cucover::FeatureExtensions
# Cucover::Monkey.extend_every Cucumber::Ast::Scenario       => Cucover::ScenarioExtensions
# Cucover::Monkey.extend_every Cucumber::Ast::Background     => Cucover::BackgroundExtensions
# Cucover::Monkey.extend_every Cucumber::Ast::StepInvocation => Cucover::RecordsFailures

module Cucover
  class << self
    def start_recording(scenario_or_table_row)
      raise("Already recording. Please call stop first.") if recording?
      
      @current_recording = Recording.new(scenario_or_table_row)
      @current_recording.start
    end
    
    def record_file(source_file)
      @current_recording.record_file(source_file)
    end
    
    def record_exception(exception)
      @current_recording.fail!(exception)
    end

    def stop_recording
      return unless recording?
      @current_recording.stop
      store.keep(@current_recording)
      @current_recording = nil
    end
    
    def logger
      Logging::Logger['Cucover']
    end
        
    private
    
    def recording?
      !!@current_recording
    end
    
    def store
      store ||= Store.new
    end
  end
end

Before do |scenario_or_table_row|
  Cucover::Rails.patch_if_necessary  

  announce "[ Cucover - Skipping clean scenario ]"
  scenario_or_table_row.skip_invoke! 
  # Cucover.start_recording(scenario_or_table_row)
end

After do
  Cucover.stop_recording
end
