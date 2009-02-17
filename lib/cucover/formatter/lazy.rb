require 'cucumber'
require 'rcov'

module Cucover
  module Formatter
    class Lazy < Cucumber::Ast::Visitor

      def initialize(step_mother, io, options)
        super(step_mother)
        @io = io
        @options = options
        @analyzer = Rcov::CodeCoverageAnalyzer.new
      end

      def visit_features(features)
        @features = features
        super
        @io.puts
        print_counts(features)
      end

      def visit_feature(feature)
        @analyzer.run_hooked do
          super
        end
        @io.puts feature.file
        analyzed_files.each do |f|
          @io.puts "  #{f}"
        end
      end
      
      private 
      
      def analyzed_files
        interesting_files = @analyzer.analyzed_files.map{ |f| File.expand_path(f) }.reject{ |f| boring?(f) }
        interesting_files.map do |file|
          file.gsub(/^#{Dir.pwd}\//, '')
        end
      end
      
      def boring?(file)
        file.match /gem/
      end
      
      def print_counts(features)
        @io.puts dump_count(features.scenarios.length, "scenario")

        [:failed, :skipped, :undefined, :pending, :passed].each do |status|
          if features.steps[status].any?
            count_string = dump_count(features.steps[status].length, "step", status.to_s)
            @io.puts count_string
            @io.flush
          end
        end
      end
      
      def dump_count(count, what, state=nil)
        [count, state, "#{what}#{count == 1 ? '' : 's'}"].compact.join(" ")
      end
      

    end
  end
end
