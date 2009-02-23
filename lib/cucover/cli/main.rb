require 'cucover'
require 'cucover/formatter/lazy'
require 'cucumber'

module Cucover
  module Cli
    
    module LazyConfiguration
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
      
      def configuration
        super.extend(LazyConfiguration)
      end
      
    end
  end
end

Cucover::Cli::Main.step_mother = self
