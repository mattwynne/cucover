module Cucover
  module Commands
    class CoverageOf
      def initialize(cli_args)
        @filespec = cli_args[1]
        @store = Store.new
      end
      
      def execute
        return unless recordings.any?

        File.open(@filespec).each_with_index do |line_content, index|
          line_number = index + 1
          coverage_text = coverage(line_number).join(', ').ljust(25)
          puts "#{line_number} #{coverage_text} #{line_content}"
        end
      end
      
      def coverage(line_number)
        @recordings.select{ |r| r.covers_line?(line_number) }.map{ |r| r.feature_filename }
      end
      
      def recordings
        @recordings ||= @store.fetch_recordings_covering(@filespec)
      end
    end
  end
end