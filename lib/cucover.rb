$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rubygems'
require 'rcov'

module Cucover
  
  class << self
    def record(file)
      additional_covered_files << file
    end
    def additional_covered_files
      @additional_covered_files ||= []
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
    
    def any_dirty_files?
      not dirty_files.empty?
    end
    
    def time
      File.mtime(cache_filename)
    end

    private

    def dirty_files
      source_files.select do |source_file|
        File.mtime(Dir.pwd + '/' + source_file.strip) >= time
      end
    end
    
    def source_files
      result = []
      File.open(cache_filename, "r") do |file|
        file.each_line do |line|
          result.push line
        end
      end
      result
    end
    
    def cache_filename
      @feature_file.gsub /([^\/]*\.feature)/, '.coverage/\1'
    end
  end
  
  module LazyFeature
    
    def accept(visitor)
      return unless dirty?
      Cucover.additional_covered_files.clear
      analyzer.run_hooked do
        super
      end
      source_files_cache.save analyzed_files
    end

    private
    
    def dirty?
      return true unless source_files_cache.exists?
      return true if changed_since_last_run?
      source_files_cache.any_dirty_files?
    end
    
    def changed_since_last_run?
      File.mtime(@file) >= source_files_cache.time
    end

    def source_files_cache
      @source_files_cache ||= SourceFileCache.new(@file)
    end

    def source_files
      analyzed_files
    end
    
    def analyzed_files
      normalized_files.reject{ |f| boring?(f) }.sort
    end
    
    def normalized_files
      (analyzer.analyzed_files + Cucover.additional_covered_files.uniq).map{ |f| File.expand_path(f).gsub(/^#{Dir.pwd}\//, '') }
    end
    
    def boring?(file)
      (file.match /gem/) || (file.match /vendor/) || (file.match /lib\/ruby/)
    end
    
    def analyzer
      @analyzer ||= Rcov::CodeCoverageAnalyzer.new      
    end
  end
  
  module LazyFeatures
    def add_feature(feature)
      super feature.extend(LazyFeature)
    end
  end
  
  module Rails
    class << self
      def patch_if_necessary
        return if @patched
        return unless defined?(ActionView)
        
        ActionView::Template.instance_eval do
          def new(*args)
            super(*args).extend(Cucover::Rails::RecordsRenders)
          end
        end
        
        @patched = true
      end
    end
    
    module RecordsRenders
      def render
        Cucover.record(@filename)
        super
      end
    end
  end
end

module Cucumber
  module Ast
    class Features
      class << self
        def new(*args)
          super(*args).extend(Cucover::LazyFeatures)
        end
      end
    end
  end
end

Before do
  Cucover::Rails.patch_if_necessary
end