require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'

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
  
  ruby_bug "#", "1.8.7.17" do
    it "honors the output record separator global" do
      old_rs, $\ = $\, 'x'
    
      begin
        @io.printf("%d %04x", 123, 123)
        @io.string.should == "123 007bx"
      ensure
        $\ = old_rs
      end
    end
  end
  
  it "updates the current position" do
    @io.printf("%d %04x", 123, 123)
    @io.pos.should eql(8)
    
    @io.printf("%d %04x", 123, 123)
    @io.pos.should eql(16)
   end
  
  ruby_bug "#", "1.8.7.17" do
    it "correctly updates the current position when honoring the output record separator global" do
      old_rs, $\ = $\, 'x'
    
      begin
        @io.printf("%d %04x", 123, 123)
        @io.pos.should eql(9)
      ensure
        $\ = old_rs
      end
    end
  end
end

describe "StringIO#printf when self is not writable" do
  it "raises an IOError" do
    io = StringIO.new("test", "r")
    lambda { io.printf("test") }.should raise_error(IOError)

    io = StringIO.new("test")
    io.close_write
    lambda { io.printf("test") }.should raise_error(IOError)
  end
end
