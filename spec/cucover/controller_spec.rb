require File.dirname(__FILE__) + '/../spec_helper'

describe Cucover::Controller do
  describe "#should_execute?" do
    before(:each) do
      @store = mock(Cucover::Recording::Store)
      Cucover::Recording::Store.stub!(:new).and_return(@store)
      @example = mock('Example', :file_colon_line => 'foo.feature:123')
    end
    it "when no previous recording exists, it should always return true" do
      @store.should_receive(:latest_recording).with(@example.file_colon_line).and_return(nil)
      Cucover::Controller[@example].should_execute?.should be_true
    end
  end
end
