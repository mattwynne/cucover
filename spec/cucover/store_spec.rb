require File.dirname(__FILE__) + '/../spec_helper'

module Cucover
  describe Store do
    before(:each) do
      @cache = mock('cache', :load => nil)
      @store = Store.new(@cache)
    end
    describe "#latest_recording" do
      it "should return nil if no recordings match the given identifier" do
        @store.latest_recording('blah:234').should be_nil
      end
      
      describe "when multiple recordings match the given indentifier" do
        before(:each) do
          old_recording = mock('old data', :end_time => Time.now - 200)
          @new_recording = mock('new data', :end_time => Time.now)
          @cache.stub!(:load).and_return({
            'foo.feature:33' => [ old_recording, @new_recording ] 
          })
        end
        it "should return the one with the latest end_time" do
          @store.latest_recording('foo.feature:33').should == @new_recording
        end        
      end
    end
  end
end