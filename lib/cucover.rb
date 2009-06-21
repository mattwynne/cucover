$:.unshift(File.dirname(__FILE__)) 
require 'dependencies'
require 'cucover/cli_commands/coverage_of'
require 'cucover/cli_commands/cucumber'
require 'cucover/cli_commands/show_recordings'
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
