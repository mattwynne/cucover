require 'cucover/recording/recorder'
require 'cucover/recording/data'
require 'cucover/recording/covered_file'
require 'cucover/recording/store'

module Cucover
  module Recording
    class << self
      def start(scenario_or_table_row)
        raise("Already recording. Please call stop first.") if recording?
      
        @current_recorder = Recording::Recorder.new(scenario_or_table_row)
        @current_recorder.start
        record_file(scenario_or_table_row.file_colon_line.split(':').first) # TODO: clean this by extending the feature element
      end
    
      def stop
        return unless recording?
        @current_recorder.stop
        store.keep(@current_recorder.to_data)
        @current_recorder = nil
      end
      
      def record_file(source_file)
        Cucover.logger.debug("Recording extra source file #{source_file}")
        @current_recorder.record_file(source_file)
      end
    
      def record_exception(exception)
        @current_recorder.fail!(exception)
      end

      private
    
      def recording?
        !!@current_recorder
      end
    
      def store
        store ||= Recording::Store.new
      end
    end
  end
end