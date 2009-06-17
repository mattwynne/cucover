module Cucover
  module Recording
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
  end
end    
