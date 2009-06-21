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
require 'cucover/commands/show_recordings'
require 'cucover/logging_config'
require 'cucover/monkey'
require 'cucover/rails'
require 'cucover/recording'
require 'cucover/controller'
require 'cucover/cli'

# 
# module Cucover
#   
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
    def logger
      Logging::Logger['Cucover']
    end        
  end
  
end
