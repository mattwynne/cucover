module Cucover
  module Formatter
    class CoverageReporter
      def initialize(io)
        @io = io
      end
  
      def visit_features(features)
        return if features.source_files.empty?
        @io.puts
        @io.puts "Coverage"
        @io.puts "--------"
        @io.puts
        features.accept(self)
        @io.puts
      end
  
      def visit_feature(feature)
        @io.puts feature.file
        feature.source_files.each do |f|
          @io.puts "  #{f}"
        end
      end
    end
  end
end