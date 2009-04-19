module Cucover
  module LazyScenario
    include LazyTestCase

    def test_identifier
      return TestIdentifier.new(@feature.file, @line, @background.test_identifier) if @background
      super
    end    
  end
end