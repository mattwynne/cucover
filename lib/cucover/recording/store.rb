module Cucover
  module Recording
    class Store
      def initialize(cache = DiskCache.new)
        @cache = cache
      end
      
      def latest_recordings
        recordings.keys.map{ |file_colon_line| latest_recording(file_colon_line) }
      end
    
      def latest_recording(file_colon_line)
        recordings[file_colon_line].sort{ |x, y| x.end_time <=> y.end_time }.last
      end
    
      def keep(recording_data)
        Cucover.logger.debug("Storing recording of #{recording_data.file_colon_line}")
        recordings[recording_data.file_colon_line] << recording_data
        @cache.save(@recordings)
      end
    
      def recordings_covering(source_file)
        latest_recordings.select { |r| r.covers_file?(source_file) }
      end
    
      def recordings
        ensure_recordings_loaded!
        @recordings
      end
    
      private
    
      def ensure_recordings_loaded!
        return if @recordings
        
        if @recordings = @cache.load
          Cucover.logger.debug("Loaded #{@recordings.length} recording(s)")
        else
          Cucover.logger.debug("Starting with no existing coverage data.")
          @recordings = Recordings.new
        end
      end
      
      class Recordings < Hash
        def [](key)
          self[key] = [] if super.nil?
          super
        end        
        
        def dump
          dump = []
          each do |file_colon_line, recordings|
            dump << "#{file_colon_line} #{recordings.map{ |r| r.to_s }}"
          end
          dump
        end
      end
      
      class DiskCache
        def save(recordings)
          Cucover.logger.debug("Saving #{recordings.length} recording(s) to #{data_file}")
          File.open(data_file, 'w') { |f| f.puts Marshal.dump(recordings) }
        end
        
        def load
          return unless File.exists?(data_file)
          
          Cucover.logger.debug("Reading existing coverage data from #{data_file}")
          File.open(data_file) { |f| Marshal.load(f) }
        end
        
        private
        
        def data_file
          Dir.pwd + '/cucover.data'
        end
      end
    end
  end
end