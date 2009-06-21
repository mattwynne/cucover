module Cucover
  class Cli
    def initialize(args)
      @args = args
    end

    def start
      command_type.new(@args).execute
    end
    
    private
    
    def command_type
      if @args.index('--')
        CliCommands::Cucumber
      elsif @args.index('--coverage-of')
        CliCommands::CoverageOf
      elsif @args.index('--show-recordings')
        CliCommands::ShowRecordings
      else
        raise("Sorry: I don't understand these command line arguments: #{@args.inspect}. Soon I will say something more helpful here.")
      end
    end
    
  end
end