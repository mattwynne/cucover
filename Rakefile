require 'cucumber/rake/task'

module Cucover
  module Rake
    class Task < Cucumber::Rake::Task
      def feature_pattern=(value)
        @feature_pattern = value
      end
      
      def pretty!
        @format = 'pretty'
      end
      
      def tags=(value)
        @tags = value
      end
      
      private
      
      def feature_pattern
        @feature_pattern || 'features/**/*.feature'
      end
      
      def feature_files(task_arguments = nil)
        FileList[feature_pattern]
      end
      
      def formatters
        [
          '-f', 'rerun', '-o', 'rerun',
          '-f', @format || 'progress',
        ]        
      end
      
      def tags
        return [] unless @tags
        [ '-t', @tags ]
      end
      
      def cucumber_opts
        formatters + tags
      end      
    end
  end
end

def rerun
  return nil unless File.exist?('rerun')
  result = File.read('rerun').strip
  return nil if result.empty?
  result
end

Cucover::Rake::Task.new(:default) do |t|
  t.tags = '~in-progress'
end

Cucover::Rake::Task.new(:all)

Cucover::Rake::Task.new(:failed) do |t|
  t.pretty!
  t.feature_pattern = rerun if rerun
end

Cucumber::Rake::Task.new(:coverage) do |t|
  t.rcov = true
  t.rcov_opts = %w{--exclude osx\/objc,gems\/,spec\/}
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "cucover"
    gemspec.summary = "Lazy coverage-aware running of Cucumber acceptance tests"
    gemspec.email = "matt@mattwynne.net"
    gemspec.homepage = "http://github.com/mattwynne/cucover/"
    gemspec.description = "Lazy coverage-aware running of Cucumber acceptance tests"
    gemspec.authors = ["Matt Wynne"]
    
    gemspec.add_dependency('cucumber',        '>= 0.3.11')
    gemspec.add_dependency('relevance-rcov',  '>= 0.8.3.4')
    gemspec.add_dependency('logging',         '>= 0.9.7')
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end
