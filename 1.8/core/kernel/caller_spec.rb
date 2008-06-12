require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'

# DO NOT PUT ANYTHING ABOVE THIS
describe "Kernel#caller" do
  before :each do
    def a(skip)
      caller(skip)
    end
    def b(skip)
      a(skip)
    end
    def c(skip)
      b(skip)
    end
  end
  
  it "is a private method" do
    Kernel.private_instance_methods.should include("caller")
  end
  
  it "returns the current call stack" do
    stack = c 0
    stack[0].should =~ /caller_spec.rb.*?8.*?`a'/
    stack[1].should =~ /caller_spec.rb.*?11.*?`b'/
    stack[2].should =~ /caller_spec.rb.*?14.*?`c'/
  end
  
  it "omits a number of frames corresponding to the parameter" do
    c(0)[1..-1].should == c(1)
    c(0)[2..-1].should == c(2)
    c(0)[3..-1].should == c(3)
  end
  
  it "defaults to omitting one frame" do
    caller.should == caller(1)
  end

  # The contents of the array returned by #caller depends on whether
  # the call is made from an instance_eval block or a <block>#call.
  # We purposely do not spec what happens if you request to omit
  # more entries than exist in the array returned.
end

describe "Kernel#caller in a Proc or eval" do
  it "should return the definition trace of a block when evaluated in a Proc binding" do
    stack = CallerFixture.caller_of(CallerFixture.block)
    stack[0].should =~ /caller_fixture1\.rb:4/
    stack[1].should =~ /caller_fixture1\.rb:4:in `require'/
  end

  it "should return the definition trace of a Proc" do
    pr = Proc.new do
      1 + 1
      2 + 2
    end

    stack = CallerFixture.caller_of(CallerFixture.example_proc)
    stack[0].should =~ /caller_fixture1\.rb:13:in `example_proc'/
    stack[1].should =~ /caller_fixture1\.rb:13/
  end
end
