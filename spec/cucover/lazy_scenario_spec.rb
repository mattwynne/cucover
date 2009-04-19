require File.dirname(__FILE__) + '/../spec_helper'

module Cucover
  describe LazyScenario do
    TestScenario = Class.new do
      def initialize(feature, line, background = nil)
        @feature, @line, @background = feature, line, background
      end
      
      def accept(visitor)
      end
    end
    
    before(:each) do
      @line = 123
      @feature = mock('feature', :file => 'path/to/test_feature.feature')
      @visitor = mock('visitor')
    end
    
    describe "in a feature with no background" do
      before(:each) do        
        @scenario = TestScenario.new(@feature, @line).extend(LazyScenario)
      end
      
      it "should tell Cucover it's starting when asked to accept a visitor" do
        Cucover.should_receive(:start_test) do |test_identifier, visitor|
          visitor.should == @visitor
          test_identifier.file.should == @feature.file
          test_identifier.line.should == @line
          test_identifier.depends_on.should be_nil
        end
        @scenario.accept(@visitor)
      end
    end
  
    describe "in a feature with a background" do
      before(:each) do
        @background = mock('background', :test_identifier => mock('background_test_identifier'))
        @scenario = TestScenario.new(@feature, @line, @background).extend(LazyScenario)
      end

      it "should tell Cucover it's starting when asked to accept a visitor, passing the background test as a dependency" do
        Cucover.should_receive(:start_test) do |test_identifier, visitor|
          visitor.should == @visitor
          test_identifier.file.should == @feature.file
          test_identifier.line.should == @line
          test_identifier.depends_on.should == @background.test_identifier
        end
        @scenario.accept(@visitor)
      end
    end
  end
end