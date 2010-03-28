module Cucover
  module CliCommands
    class CoverageOf
      CODE_COLUMN_WIDTH = 15

      def initialize(cli_args)
        @filespec = cli_args[1]
        @store = Store.new
      end

      def execute
        load_cucumber_enviroment
        return unless recordings.any?

        File.open(@filespec).each_with_index do |line_content, index|
          line_number = index + 1
          coverage_text = coverage(line_number).join(', ')
          line_content.rstrip!
          if line_content.length > CODE_COLUMN_WIDTH
            truncated_line_content = "#{line_content[0..(CODE_COLUMN_WIDTH - 1)]}.."
          else
            truncated_line_content = "#{line_content}  "
          end
          puts "#{line_number} #{truncated_line_content.ljust(CODE_COLUMN_WIDTH + 2)} #{coverage_text}"
        end
      end

      def coverage(line_number)
        recordings.select{ |r| r.covers_line?(@filespec, line_number) }.map{ |r| r.file_colon_line }
      end

      def recordings
        @recordings ||= @store.recordings_covering(@filespec)
      end

      private
      def load_cucumber_enviroment
        support_files = Dir['features/**/*'].select {|file| file =~ /support\/env\..*/ }
        support_files.each{ |env_file| puts env_file; require env_file }
      end

    end
  end
end