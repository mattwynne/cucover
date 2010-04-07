module Cucover
  module CliCommands
    class Cucumber

      LANGUAGE = 'rb'

      class << self
        attr_accessor :exit_status
      end

      def initialize(cli_args)
        Cucumber.exit_status = 0
        @cli_args = cli_args
      end

      def execute
        require 'rubygems'
        require 'cucumber'

        step_mother = ::Cucumber::StepMother.new
        step_mother.load_programming_language(LANGUAGE)
        require 'cucover/cucumber_hooks'

        execute_cuke do
          ::Cucumber::Cli::Main.new(ARGV).execute!(step_mother)
        end
      end

      private

      def execute_cuke
        ARGV.replace cucumber_args
        Cucumber.exit_status = yield
        Cucumber.exit_status = Cucumber.exit_status ? 1 : 0
        ARGV.replace @cli_args
      end

      def cucumber_args
        return nil unless @cli_args.index('--')
        first = @cli_args.index('--') + 1
        last = @cli_args.length - 1
        @cli_args[first..last]
      end
    end
  end
end
