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

      def initialize(step_mother, io, options)
        super(step_mother)
        @io = io
        @options = options
        @analyzer = Rcov::CodeCoverageAnalyzer.new
        @pretty_io = StringIO.new.extend(LooksLikeTerminal)
        @pretty_formatter = Cucumber::Formatter::Pretty.new(step_mother, @pretty_io, @options)
      end

      def visit_features(features)
        features.extend(FeaturesExtensions)
        super
        
        CoverageReporter.new(@io).visit_features(features)

        print_counts(features)
        @io.puts
      end

      def visit_feature(feature)
        feature.extend(FeatureExtensions)
        @analyzer.run_hooked do
          super
        end
        feature.analyzed_files = analyzed_files
        
        @pretty_formatter.visit_feature(feature)
        feature.last_run = @pretty_io.string
        @pretty_io.string == ""
        @io.puts feature.last_run
        @io.puts
        
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
