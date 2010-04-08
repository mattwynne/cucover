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
      case @args.first
      when '--'
        CliCommands::Cucumber
      when '--version', '-v'
        CliCommands::Version
      when '--coverage-of', '-c'
        CliCommands::CoverageOf
      when '--show-recordings', '-s'
        CliCommands::ShowRecordings
      else
        puts help
        Kernel.exit(0)
      end
    end
    
      def help
        <<-EOH
Usage: cucover -- [options] [ [FILE|DIR|URL][:LINE[:LINE]*] ]+

Examples:
cucover -- --format pretty features
cucover --coverage-of lib/monkeys.rb
cucover --show-recordings

    -- [ARGS]                               Run cucumber while recording coverage. This will skip scenarios 
                                            if they have already been run and the covering code has not
                                            been changed.
    -c [FILE], --coverage-of [FILE]         Show file with feature coverage information
    -s,        --show-recordings            Show all coverage information currently recorded
    -v,        --version                    Show version
    -h,        --help                       You're looking at it.

EOH
      end
    
  end
end