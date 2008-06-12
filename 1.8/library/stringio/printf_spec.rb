require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'

describe "StringIO#printf when in read-only mode" do
  it "raises an IOError" do
    io = StringIO.new("test", "r")
    lambda { io.printf("test") }.should raise_error(IOError)

    io = StringIO.new("test")
    io.close_write
    lambda { io.printf("test") }.should raise_error(IOError)
  end
end

describe "StringIO#printf" do
  before(:each) do
    @io = StringIO.new('')
  end

  it "returns nil" do
    @io.printf("%d %04x", 123, 123).should be_nil
  end

  it "performs format conversion" do
    @io.printf("%d %04x", 123, 123)
    @io.string.should == "123 007b"
  end
  
  it "correctly updates the current position" do
    @io.printf("%d %04x", 123, 123)
    @io.pos.should eql(8)
  end
end
