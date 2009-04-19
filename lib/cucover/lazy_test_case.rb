module Cucover
  module LazyTestCase
    def accept(visitor)      
      Cucover.start_test(test_identifier, visitor) do
        super
      end
    end
    
    def test_identifier
      TestIdentifier.new(@feature.file, @line)
    end

  end
end