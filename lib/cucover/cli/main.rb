require 'cucover'
require 'cucover/formatter/lazy'
require 'cucumber'

module Cucover
  module Cli
    
    module MyConfiguration
      def build_formatter_broadcaster(step_mother)
        Cucover::Formatter::Lazy.new(step_mother, STDOUT, {})
      end
    end
    
    class Main < Cucumber::Cli::Main
      class << self
        def execute(args)
          new(args).execute!(@step_mother)
        end
      end
      
      def execute!(step_mother)
        configuration.load_language
        step_mother.options = configuration.options

        require_files
        enable_diffing
      
        features = load_plain_text_features

        visitor = configuration.build_formatter_broadcaster(step_mother)
        visitor.visit_features(features)
      
        failure = features.steps[:failed].any? || (configuration.strict? && features.steps[:undefined].length)
        Kernel.exit(failure ? 1 : 0)
      end
      
      def configuration
        super.extend(MyConfiguration)
      end
      
    end
  end
end

Cucover::Cli::Main.step_mother = self
