require 'cucumber'

module Cucover
  module Formatter
    # This formatter prints features to plain text - exactly how they were parsed,
    # just prettier. That means with proper indentation and alignment of table columns.
    #
    # If the output is STDOUT (and not a file), there are bright colours to watch too.
    #
    class Lazy < Cucumber::Ast::Visitor

      def initialize(step_mother, io, options)
        super(step_mother)
        @io = io
        @options = options
      end

      def visit_features(features)
        @features = features
        super
        @io.puts
        print_counts(features)
      end

      def visit_feature(feature)
        super
        @io.puts feature.file
      end
      
      private 
      
      def print_counts(features)
        @io.puts dump_count(features.scenarios.length, "scenario")

        [:failed, :skipped, :undefined, :pending, :passed].each do |status|
          if features.steps[status].any?
            count_string = dump_count(features.steps[status].length, "step", status.to_s)
            @io.puts count_string
            @io.flush
          end
        end
      end
      
      def dump_count(count, what, state=nil)
        [count, state, "#{what}#{count == 1 ? '' : 's'}"].compact.join(" ")
      end
      

    end
  end
end
