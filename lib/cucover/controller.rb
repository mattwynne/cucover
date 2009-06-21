module Cucover
  class Controller
    def initialize(file_colon_line, store)
      @file_colon_line = file_colon_line
      @store = store
    end
    
    def should_execute?
      dirty? or failed_on_last_run?
    end
    
    private
    
    def failed_on_last_run?
      return false unless recording
      recording.failed?
    end
    
    def dirty?
      Cucover.logger.debug("Assuming dirty as no recording found") and return true unless recording
      recording.covered_files.any?{ |f| f.dirty? }
    end
    
    def recording
      @recording ||= @store.latest_recording(@file_colon_line)
    end
  end
end