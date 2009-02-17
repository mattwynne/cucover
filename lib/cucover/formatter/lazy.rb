require 'cucumber/formatter/console'
require 'fileutils'

module Cucover
  module Formatter
    # This formatter prints features to plain text - exactly how they were parsed,
    # just prettier. That means with proper indentation and alignment of table columns.
    #
    # If the output is STDOUT (and not a file), there are bright colours to watch too.
    #
    class Lazy < Cucumber::Ast::Visitor
      include Cucumber::Formatter::Console

      def initialize(step_mother, io, options)
        super(step_mother)
        @io = io
        @options = options
      end

      def visit_features(features)
        @features = features
        super
        print_counts(features)
      end

      def visit_feature(feature)
        super
        @io.puts feature.file
      end

    end
  end
end
