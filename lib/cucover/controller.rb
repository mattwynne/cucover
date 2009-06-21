module Cucover
  class Controller
    class << self
      def [](scenario_or_table_row)
        new(scenario_or_table_row.file_colon_line)
      end
    end
    
    def initialize(file_colon_line)
      @file_colon_line = file_colon_line
      @store = Recording::Store.new
    end
    
    def should_execute?
      dirty?
    end
    
    private
    
    # def failed_on_last_run?
    #   return false unless recording
    #   recording.result_failed?
    # end
    
    def dirty?
      Cucover.logger.debug("Assuming dirty as no recording found") and return true unless recording
      recording.covered_files.any?{ |f| f.dirty? }
    end
    
    def recording
      @recording ||= @store.latest_recording(@file_colon_line)
    end
  end
end