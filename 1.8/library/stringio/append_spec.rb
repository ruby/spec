require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'

describe "StringIO#<<" do
  before(:each) do
    @io = StringIO.new("example")
  end
  
  it "returns self" do
    (@io << "just testing").should equal(@io)
  end

  it "writes the passed argument onto self" do
    (@io << "just testing").string.should == "just testing"
    (@io << " and more testing").string.should == "just testing and more testing"
  end
  
  it "taints self's String when the passed argument is tainted" do
    (@io << "test".taint).string.tainted?.should be_true
  end
  
  it "does not taint self when the passed argument is tainted" do
    (@io << "test".taint).tainted?.should be_false
  end
  
  it "updates self's position" do
    @io << "test"
    @io.pos.should eql(4)
  end
  
  # NOTE: This IS NOT what Ruby's Core Libs do!
  it "tries to convert the passed argument to a String using #to_s" do
    obj = mock("to_s")
    obj.should_receive(:to_s).and_return("Test")
    
    (@io << obj).string.should == "Testple"
  end
end

describe "StringIO#<< when self is not writable" do
  it "raises an IOError" do
    io = StringIO.new("test", "r")
    lambda { io << "test" }.should raise_error(IOError)

    io = StringIO.new("test")
    io.close_write
    lambda { io << "test" }.should raise_error(IOError)
  end
end

describe "StringIO#<< when in append mode" do
  before(:each) do
    @io = StringIO.new("example", "a")
  end

  it "appends the passed argument to the end of self" do
    (@io << ", just testing").string.should == "example, just testing"
    (@io << " and more testing").string.should == "example, just testing and more testing"
  end
  
  it "correctly updates self's position" do
    @io << ", testing"
    @io.pos.should eql(16)
  end
end
