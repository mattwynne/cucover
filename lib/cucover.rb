$:.unshift(File.dirname(__FILE__))
require 'dependencies'
require 'cucover/logging_config'
require 'cucover/cli_commands/coverage_of'
require 'cucover/cli_commands/cucumber'
require 'cucover/cli_commands/show_recordings'
require 'cucover/cli_commands/version'
require 'cucover/controller'
require 'cucover/cli'
require 'cucover/monkey'
require 'cucover/rails'
require 'cucover/recording'
require 'cucover/recorder'
require 'cucover/store'
require 'cucover/line_numbers'


require 'at_exit_hook'

module Cucover
  class << self
    def logger
      Logging::Logger['Cucover']
    end

    def should_execute?(scenario_or_table_row)
      controller(scenario_or_table_row).should_execute?
    end

    def start_recording!(scenario_or_table_row)
      raise("Already recording. Please call stop first.") if recording?

      @current_recorder = Recorder.new(scenario_or_table_row)
      @current_recorder.start!
      record_file(scenario_or_table_row.file_colon_line.split(':').first) # TODO: clean this by extending the feature element
    end

    def stop_recording!
      return unless recording?

      @current_recorder.stop!
      store.keep!(@current_recorder.recording)
      @current_recorder = nil
    end

    def record_file(source_file)
      Cucover.logger.debug("Recording extra source file #{source_file}")
      @current_recorder.record_file!(source_file)
    end

    private

    def controller(scenario_or_table_row)
      Controller.new(scenario_or_table_row.file_colon_line, store)
    end

    def recording?
      !!@current_recorder
    end

    def store
      @store ||= Store.new
    end
  end
end
