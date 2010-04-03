module Cucover
  class Recording::CoveredFile
    attr_reader :file

    def initialize(full_filename, rcov_marked_info, recording)
      @full_filename    = full_filename
      @rcov_marked_info = rcov_marked_info
      @recording        = recording
      @file = File.expand_path(full_filename).gsub(/^#{Dir.pwd}\//, '')

      extend HasLineNumberDetail if @rcov_marked_info
    end

    def dirty?
      Cucover.logger.debug("#{file}     last modified at #{File.mtime(@full_filename)}")
      Cucover.logger.debug("#{file} recording started at #{@recording.start_time}")
      result = File.mtime(@full_filename).to_i >= @recording.start_time.to_i
      Cucover.logger.debug("verdict: #{(result ? "dirty" : "not dirty")}")
      result
    end

    def covers_line?(line_number)
      covered_lines.include?(line_number)
    end

    def ==(other)
      other == file
    end

    def to_s
      "#{file}:#{covered_lines.join(':')}"
    end

    private

    def covered_lines
      ['<unknown lines>']
    end

    module HasLineNumberDetail
      def covered_lines
        return @covered_lines if @covered_lines

        @covered_lines = []
        @rcov_marked_info.each_with_index do |covered, index|
          line_number = index + Cucover::LineNumbers.offset
          @covered_lines << line_number if covered
        end
        @covered_lines
      end
    end
  end
end
