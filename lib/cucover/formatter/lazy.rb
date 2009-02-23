require 'cucumber'
require 'rcov'
require 'cucover/formatter/lazy/coverage_reporter'

module Cucover
  
  module FeaturesExtensions
    def source_files
      result = []
      @features.each do |f|
        result << f.source_files 
      end
      result.flatten
    end
  end

  class SourceFileCache
    def initialize(feature_file)
      @feature_file = feature_file
    end
    
    def save(analyzed_files)
      FileUtils.mkdir_p File.dirname(cache_filename)
      File.open(cache_filename, "w") do |file|
        file.puts analyzed_files
      end
    end
    
    def exists?
      File.exist?(cache_filename)
    end
    
    def dirty_files
      source_files.select do |source_file|
        File.mtime(Dir.pwd + '/' + source_file.strip) > time
      end
    end
    
    private
    
    def source_files
      result = []
      File.open(cache_filename, "r") do |file|
        file.each_line do |line|
          result.push line
        end
      end
      result
    end
    
    def time
      File.mtime(cache_filename)
    end

    def cache_filename
      @feature_file.gsub /([^\/]*\.feature)/, '.coverage/\1'
    end
  end
  
  module FeatureExtensions
    def dirty?
      return true unless source_files_cache.exists?
      not source_files_cache.dirty_files.empty?
    end
    
    def accept(visitor)
      return unless dirty?
      analyzer.run_hooked do
        super
      end
      source_files_cache.save analyzed_files
    end
    
    def source_files
      analyzed_files
    end
    
    private
    
    def source_files_cache
      @source_files_cache ||= SourceFileCache.new(self.file)
    end

    def analyzed_files
      normalized_files = analyzer.analyzed_files.map{ |f| File.expand_path(f).gsub(/^#{Dir.pwd}\//, '') }
      interesting_files = normalized_files.reject{ |f| boring?(f) }
      interesting_files.sort
    end
    
    def boring?(file)
      (file.match /gem/) || (file.match /vendor/) || (file.match /lib\/ruby/)
    end
    
    def analyzer
      @analyzer ||= Rcov::CodeCoverageAnalyzer.new      
    end
  end
  
  module LooksLikeTerminal
    def tty?
      true
    end
  end
  
  module Formatter
    
    class Lazy < Cucumber::Ast::Visitor

      def initialize(step_mother, io, cucumber_options)
        super(step_mother)
        @io = io.extend(LooksLikeTerminal)
        @options = cucumber_options # needed for base class
        
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
      end

      def visit_feature(feature)
        feature.extend(FeatureExtensions)
        super if feature.dirty?
      end
      
      private 
      
      def print_counts(features)
        return if features.steps.empty?
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
        return if @rerun_io.string.strip.blank?
        @io.puts 
        @io.puts @rerun_io.string
      end
      
      def dump_count(count, what, state=nil)
        [count, state, "#{what}#{count == 1 ? '' : 's'}"].compact.join(" ")
      end

    end
  end
end
