module Cucover
  class Recording
    class Data < Struct.new(:file_colon_line, :additional_covered_files, :analyzer)
      def feature_filename
        file_colon_line.split(':').first
      end
      
      def covers_file?(source_file)
        Cucover.logger.info("looking for source file #{source_file} amongst #{covered_files.join(',')}")
        covered_files.include?(source_file)
      end
      
      def covers_line?(source_file, line_number)
        Cucover.logger.debug("Fetching coverage stats for #{source_file} from #{analyzer.analyzed_files.join(',')}")
        lines, marked_info, count_info = analyzer.data_matching(/lib\/foo\.rb/)
        re = Regexp.new(source_file.gsub('.', '\.').gsub('/', '\/')) # for some reason Regexp.escape doesn't escape the forward slashes.
        lines, marked_info, count_info = analyzer.data_matching(re)
        unless lines
          Cucover.logger.debug("Not found")
          return false
        end
        return marked_info[line_number - 1]
      end
      
      private
      
      def covered_files
        normalized_files
      end
      
      # def filter(files)
      #   files.reject!{ |f| boring?(f) }
      # end
      # 
      # def boring?(file)
      #   (file.match /gem/) || (file.match /vendor/) || (file.match /lib\/ruby/)
      # end

      def normalized_files
        (analyzer.analyzed_files + additional_covered_files).map do |filename|
          File.expand_path(filename).gsub(/^#{Dir.pwd}\//, '')
        end
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
      @analyzer.install_hook
    end

    def stop
      @analyzer.remove_hook
      Cucover.logger.info("Finished recording #{file_colon_line}.")
      Cucover.logger.debug("Covered files: #{@analyzer.analyzed_files.join(',')}")
      @analyzer.analyzed_files.each do |source_file|
        lines, marked_info, count_info = @analyzer.data_matching(source_file)
        Cucover.logger.debug("Coverage for #{source_file} found OK") if lines
      end
    end
    
    def to_data
      Data.new(file_colon_line, @additional_covered_files, @analyzer)
    end
    
    private
  end
end
