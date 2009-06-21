module Cucover
  module CliCommands
    class Cucumber
      def initialize(cli_args)
        @cli_args = cli_args
      end
      
      def execute
        require 'cucover/cucumber_hooks'
        ARGV.replace cucumber_args
        Kernel.load ::Cucumber::BINARY
        ARGV.replace @cli_args
      end
      
      private 
      
      def cucumber_args
        return nil unless @cli_args.index('--')
        first = @cli_args.index('--') + 1
        last = @cli_args.length - 1
        @cli_args[first..last]
      end
    end
  end
end
