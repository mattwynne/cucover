require 'cucumber/rake/task'

module Cucover
  module Rake
    class Task < Cucumber::Rake::Task
      def features=(value)
        @features = value
      end
      
      def pretty!
        @format = 'pretty'
      end
      
      def tags=(value)
        @tags = value
      end
      
      private
      
      def features
        [ @features || 'features' ]
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
        features + formatters + tags
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
  t.features = [ rerun || 'features' ]
end
