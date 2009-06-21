module Cucover
  module CliCommands
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
          puts "#{recording.file_colon_line}" # (#{recording.start_time.strftime('%Y-%m-%d %H:%M:%S')})
          recording.covered_files.each do |covered_file|
            puts "  #{covered_file.to_s}"
          end
        end
        puts
      end
      
      def recordings
        @recordings ||= @store.latest_recordings.sort{ |x, y| x.file_colon_line <=> y.file_colon_line }
      end
    end
  end
end