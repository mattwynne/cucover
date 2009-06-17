module Cucover
  module Commands
    class ShowRecordings
      def initialize(cli_args)
        @store = Store.new
      end
      
      def execute
        unless recordings.any?
          puts "No recordings to show. Run some tests with cucover first."
          return
        end
        
        recordings.each do |recording|
          puts
          puts recording.file_colon_line
          recording.covered_files.each do |covered_file|
            puts "  #{covered_file.to_s}"
          end
        end
        puts
      end
      
      def recordings
        @recordings ||= @store.recordings.sort{ |x, y| x.end_time <=> y.end_time }
      end
    end
  end
end