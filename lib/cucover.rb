$:.unshift(File.dirname(__FILE__)) 
require 'dependencies'
require 'cucover/commands/coverage_of'
require 'cucover/commands/cucumber'
require 'cucover/commands/show_recordings'
require 'cucover/logging_config'
require 'cucover/monkey'
require 'cucover/rails'
require 'cucover/recording'
require 'cucover/controller'
require 'cucover/cli'

module Cucover
  class << self
    def logger
      Logging::Logger['Cucover']
    end        
  end  
end
