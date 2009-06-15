require File.dirname(__FILE__) + '/../spec_helper'

describe Cucover::Cli do
  describe "given a --coverage-of command" do
    before(:each) do
      @args = ['--coverage-of', 'lib/foo.rb']
    end
    
    it "should create a CoverageOf command object and execute it" do
      Cucover::Commands::CoverageOf.should_receive(:new).with(['--coverage-of', 'lib/foo.rb']).and_return(command = mock('command'))
      command.should_receive(:execute)
      cli = Cucover::Cli.new(@args)
      cli.start
    end
  end
  
  describe "given arguments for Cucumber" do
    before(:each) do
      @args = ['--', 'c', 'd']
    end
    it "should pass the arguments after the -- to cucumber" do
      cli = Cucover::Cli.new(@args)
    
      Kernel.stub!(:load).with(Cucumber::BINARY) do
        ARGV.should == ['c', 'd']
      end
    
      cli.start
    end
  end
end
