$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rubygems'
require 'rcov'

module Cucover
  
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
    
    def time
      File.mtime(cache_filename)
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
    
    def cache_filename
      @feature_file.gsub /([^\/]*\.feature)/, '.coverage/\1'
    end
  end
  
  module LazyFeature
    
    def accept(visitor)
      return unless dirty?
      analyzer.run_hooked do
        super
      end
      source_files_cache.save analyzed_files
    end

    private
    
    def dirty?
      return true unless source_files_cache.exists?
      return true if File.mtime(@file) >= source_files_cache.time
      not source_files_cache.dirty_files.empty?
    end

    def source_files_cache
      @source_files_cache ||= SourceFileCache.new(@file)
    end

    def source_files
      analyzed_files
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
  
  module LazyFeatures
    def add_feature(feature)
      super feature.extend(LazyFeature)
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
