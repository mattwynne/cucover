module Cucover
  class Recording
    def initialize(scenario_or_table_row)
      @analyzer = Rcov::CodeCoverageAnalyzer.new
      @covered_files = []
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
    end
  end
end
