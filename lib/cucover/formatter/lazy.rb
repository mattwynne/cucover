require 'cucumber'
require 'rcov'

module Cucover
  
  module FeaturesExtensions
    def run_logs
      @features.map{ |f| f.last_run }
    end    
  end
  
  module FeatureExtensions
    attr_accessor :last_run
    attr_accessor :analyzed_files
  end
  
  module LooksLikeTerminal
    def tty?
      true
    end
  end
  
  module Formatter
    
    class CoverageReporter
      def initialize(io)
        @io = io
      end
      
      def visit_features(features)
        @io.puts
        @io.puts "Coverage"
        @io.puts "--------"
        @io.puts
        features.accept(self)
        @io.puts
      end
      
      def visit_feature(feature)
        @io.puts feature.file
        feature.analyzed_files.each do |f|
          @io.puts "  #{f}"
        end
      end
    end
    
    class Lazy < Cucumber::Ast::Visitor

      def initialize(step_mother, io, cucumber_options)
        super(step_mother)
        @io = io.extend(LooksLikeTerminal)
        @options = cucumber_options # needed for subclass
        @analyzer = Rcov::CodeCoverageAnalyzer.new
        
        @rerun_io = StringIO.new
        @rerun = Cucumber::Formatter::Rerun.new(@step_mother, @rerun_io, @options)
      end

      def visit_features(features)
        features.extend(FeaturesExtensions)
        super
        @rerun.visit_features(features)
        
        CoverageReporter.new(@io).visit_features(features)
        
        print_counts(features)
        report_errors(features)
        @io.puts
      end

      def visit_feature(feature)
        feature.extend(FeatureExtensions)
        @analyzer.run_hooked do
          super
        end
        feature.analyzed_files = analyzed_files
      end
      
      private 
      
      def analyzed_files
        normalized_files = @analyzer.analyzed_files.map{ |f| File.expand_path(f).gsub(/^#{Dir.pwd}\//, '') }
        interesting_files = normalized_files.reject{ |f| boring?(f) }
        interesting_files.sort
      end
      
      def boring?(file)
        (file.match /gem/) || (file.match /vendor/) || (file.match /lib\/ruby/)
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
      
      def report_errors(features)
        @io.puts
        @io.puts @rerun_io.string
      end
      
      def dump_count(count, what, state=nil)
        [count, state, "#{what}#{count == 1 ? '' : 's'}"].compact.join(" ")
      end

    end
  end
end
