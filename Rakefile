require 'cucumber/rake/task'

module Cucover
  module Rake
    class Task < Cucumber::Rake::Task
      def features=(features)
        @features = features
      end
      
      def pretty!
        @format = 'pretty'
      end
      
      private
      
      def cucumber_opts
        [
          @features || 'features',
          '-f', 'rerun', '-o', 'rerun',
          '-f', @format || 'progress',
        ]
      end      
    end
  end
end

def rerun
  return nil unless File.exist?('rerun')
  result = File.read('rerun')
  return nil if result.strip.empty?
  result
end

Cucover::Rake::Task.new(:default)

Cucover::Rake::Task.new(:failures) do |t|
  t.pretty!
  t.features = [ rerun || 'features' ]
end
