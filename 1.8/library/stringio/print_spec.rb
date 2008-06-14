require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'

describe "StringIO#print" do
  before(:each) do
    @io = StringIO.new('')
  end

  it "prints the passed arguments to self" do
    @io.print(5, 6, 7, 8)
    @io.string.should == "5678"
  end
  
  it "returns nil" do
    @io.print(1, 2, 3).should be_nil
  end

  it "honors the output record separator global" do
    old_rs, $\ = $\, 'x'
    
    begin
      @io.print(5, 6, 7, 8)
      @io.string.should == '5678x'
    ensure
      $\ = old_rs
    end
  end
  
  it "updates the current position" do
    @io.print(1, 2, 3)
    @io.pos.should eql(3)
    
    @io.print(1, 2, 3)
    @io.pos.should eql(6)
  end
  
  it "correctly updates the current position when honoring the output record separator global" do
    old_rs, $\ = $\, 'x'
    
    begin
      @io.print(5, 6, 7, 8)
      @io.pos.should eql(5)
    ensure
      $\ = old_rs
    end
  end
end

describe "StringIO#print when in append mode" do
  before(:each) do
    @io = StringIO.new("example", "a")
  end

  it "appends the passed argument to the end of self" do
    @io.print(", just testing")
    @io.string.should == "example, just testing"
    
    @io.print(" and more testing")
    @io.string.should == "example, just testing and more testing"
  end

  it "correctly updates self's position" do
    @io.print(", testing")
    @io.pos.should eql(16)
  end
end

describe "StringIO#print when self is not writable" do
  it "raises an IOError" do
    io = StringIO.new("test", "r")
    lambda { io.print("test") }.should raise_error(IOError)

    io = StringIO.new("test")
    io.close_write
    lambda { io.print("test") }.should raise_error(IOError)
  end
end
