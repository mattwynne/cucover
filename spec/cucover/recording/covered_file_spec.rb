require File.dirname(__FILE__) + '/../../spec_helper'

class Cucover::Recording
  describe CoveredFile do
    describe "with a marked info" do
      before(:each) do
        @recording = mock('Recording')
        @covered_file = CoveredFile.new("foo.rb", [true, true, false], @recording)        
      end
      
      it "should set the covered_lines correctly from the marked info" do
        [1,2].each do |line_number|
          @covered_file.covers_line?(line_number).should be_true
        end
        
        @covered_file.covers_line?(3).should be_false
      end
    end
  end
end