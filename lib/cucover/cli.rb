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
        Commands::Cucumber
      elsif @args.index('--coverage-of')
        Commands::CoverageOf
      else
        raise("Sorry: I don't understand these command line arguments: #{@args.inspect}. Soon I will say something more helpful here.")
      end
    end
    
  end
end