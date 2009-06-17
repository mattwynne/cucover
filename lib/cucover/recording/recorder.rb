module Cucover
  module Recording
    class Recorder
      def initialize(scenario_or_table_row)
        @scenario_or_table_row = scenario_or_table_row
        @analyzer = Rcov::CodeCoverageAnalyzer.new
        @additional_covered_files = []
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
        Cucover.logger.info("Finished recording #{@scenario_or_table_row.file_colon_line}.")
        Cucover.logger.debug("Covered files: #{@analyzer.analyzed_files.join(',')}")
      end
    
      def to_data
        Data.new(
          @scenario_or_table_row.file_colon_line, 
          @additional_covered_files, 
          @analyzer, 
          @start_time, @end_time)
      end

    end
  end
end