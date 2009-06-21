require File.dirname(__FILE__) + '/../spec_helper'

module Cucover
  describe Controller do
    describe "#should_execute?" do
      before(:each) do
        @store = mock(Store)
        @example_id = 'foo.feature:123'
      end
      it "when no previous recording exists, it should always return true" do
        @store.should_receive(:latest_recording).with(@example_id).and_return(nil)
        Controller.new(@example_id, @store).should_execute?.should be_true
      end
    end
  end
end