require File.dirname(__FILE__) + '/../../spec_helper'
require 'stringio'

describe "StringIO#initialize_copy" do
  before(:each) do
    @io      = StringIO.new("StringIO example")
    @orig_io = StringIO.new("Original StringIO")
  end
  
  it "is private" do
    @io.private_methods.should include("initialize_copy")
  end
  
  it "returns self" do
    @io.send(:initialize_copy, @orig_io).should equal(@io)
  end

  it "tries to convert the passed argument to a StringIO using #to_strio" do
    obj = mock('to_strio')
    obj.should_receive(:to_strio).and_return(StringIO.new("converted"))
    @io.send(:initialize_copy, obj)
    @io.string.should == "converted"
  end
  
  it "copies the passed StringIO's content to self" do
    @io.send(:initialize_copy, @orig_io)
    @io.string.should == "Original StringIO"
  end
  
  it "copies the passed StringIO's position to self" do
    @orig_io.pos = 5
    @io.send(:initialize_copy, @orig_io)
    @io.pos.should eql(5)
  end
  
  it "taints self when the passed StringIO is tainted" do
    @orig_io.taint
    @io.send(:initialize_copy, @orig_io)
    @io.tainted?.should be_true
  end
end
