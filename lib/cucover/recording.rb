module Cucover
  class Recording
    class Data < Struct.new(:file_colon_line, :covered_files, :analyzer)
      def feature_filename
        file_colon_line.split(':').first
      end
      def covers_file?(source_file)
        Cucover.logger.info("looking for source file #{source_file} amongst #{covered_files.join(',')}")
        covered_files.include?(source_file)
      end
      def covers_line?(source_file, line_number)
        true
      end
    end
    
    def initialize(scenario_or_table_row)
      @scenario_or_table_row = scenario_or_table_row
      @analyzer = Rcov::CodeCoverageAnalyzer.new
      @covered_files = []
    end

    def file_colon_line
      @scenario_or_table_row.file_colon_line
    end
    
    def record_file(source_file)
      @covered_files << source_file unless @covered_files.include?(source_file)
    end
    
    def start
      @analyzer.install_hook
    end

    def stop
      @analyzer.remove_hook
      @covered_files.concat @analyzer.analyzed_files
      Cucover.logger.info("Finished recording #{file_colon_line}.")
      Cucover.logger.debug("Covered files: #{@covered_files.join(',')}")
      # Cucover.logger.debug("Analyzer: #{@analyzer.inspect}")
    end
    
    def to_data
      Data.new(file_colon_line, @covered_files, @analyzer)
    end
  end
end
