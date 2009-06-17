module Cucover
  class Recording
    class CoveredFile
      attr_reader :lines, :file
      
      def initialize(file, marked_info)
        @file = File.expand_path(file).gsub(/^#{Dir.pwd}\//, '')
        @lines = []
        marked_info.each_with_index do |covered, index|
          line_number = index + 1
          @lines << line_number if covered
        end
      end
      
      def to_s
        "#{file}:#{lines.join(':')}"
      end
      
      def ==(other)
        other == file
      end
    end
    
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
    
    def initialize(scenario_or_table_row)
      @scenario_or_table_row = scenario_or_table_row
      @analyzer = Rcov::CodeCoverageAnalyzer.new
      @additional_covered_files = []
    end

    def file_colon_line
      @scenario_or_table_row.file_colon_line
    end
    
    def record_file(source_file)
      unless @additional_covered_files.include?(source_file)
        @additional_covered_files << source_file 
      end
    end
    
    def start
      @start_time = Time.now
      @analyzer.install_hook
    end

    def stop
      @end_time = Time.now
      @analyzer.remove_hook
      Cucover.logger.info("Finished recording #{file_colon_line}.")
      Cucover.logger.debug("Covered files: #{@analyzer.analyzed_files.join(',')}")
    end
    
    def to_data
      Data.new(file_colon_line, @additional_covered_files, @analyzer, @start_time, @end_time)
    end

  end
end
