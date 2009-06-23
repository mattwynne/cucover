module Cucover
  module CliCommands
    class Version
      
      def initialize(cli_args)
      end
      
      def execute
        puts File.read(File.dirname(__FILE__) + '/../../../VERSION')
      end
    end
  end
end