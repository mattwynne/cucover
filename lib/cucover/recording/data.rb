module Cucover
  module Recording
    class Data < Struct.new(:file_colon_line, :additional_covered_files, :analyzer, :start_time, :end_time)
      def feature_filename
        file_colon_line.split(':').first
      end
      
      def covers_file?(source_file)
        covered_files.include?(source_file)
      end
      
      def covers_line?(source_file, line_number)
        covered_files.detect{ |f| f.file == source_file }.lines.include?(line_number)
      end
      
      def covered_files
        @covered_files ||= filtered_analyzed_files.map do |filename| 
          lines, marked_info, count_info = analyzer.data(filename)
          raise("Weird. Can't find analyzer result for covered file #{filename}") unless marked_info
          CoveredFile.new(filename, marked_info)
        end
      end
      
      private
      
      def boring?(file)
        [
          /gem/,
          /vendor/,
          /lib\/ruby/,
          /cucover/
        ].any? do |expression|
          file.match expression
        end
      end
      
      def filtered_analyzed_files
        analyzer.analyzed_files.reject{ |f| boring?(f) }
      end

      def normalized_files
        cleaned_analyzed_files + additional_covered_files
      end
    end
  end
end
