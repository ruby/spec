require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'

describe "StringIO#read when passed [length, buffer]" do
  before(:each) do
    @io = StringIO.new("example")
  end
  
  it "returns the passed buffer String" do
    @io.read(7, buffer = "").should equal(buffer)
  end
  
  it "reads length bytes and writes them to the buffer String" do
    @io.read(7, buffer = "")
    buffer.should == "example"
  end
  
  it "tries to convert the passed buffer Object to a String using #to_str" do
    obj = mock("to_s")
    obj.should_receive(:to_str).and_return(buffer = "")
    
    @io.read(7, obj)
    buffer.should == "example"
  end
  
  it "raises a TypeError when the passed buffer Object can't be converted to a String" do
    lambda { @io.read(7, Object.new) }.should raise_error(TypeError)
  end

  ruby_version_is "" ... "1.8.7" do
    it "checks whether the passed buffer Object responds to #to_str" do
      obj = mock('method_missing to_str')
      obj.should_receive(:respond_to?).with(:to_str).and_return(true)
      obj.should_receive(:method_missing).with(:to_str).and_return(buffer = "")
      @io.read(7, obj)
      buffer.should == "example"
    end
  end

  ruby_version_is "1.8.7" do
    it "checks whether the passed buffer Object responds to #to_str (including private methods)" do
      obj = mock('method_missing to_str')
      obj.should_receive(:respond_to?).with(:to_str, true).and_return(true)
      obj.should_receive(:method_missing).with(:to_str).and_return(buffer = "")
      @io.read(7, obj)
      buffer.should == "example"
    end
  end
  
  not_compliant_on :rubinius do
    it "raises an error when passed a frozen String" do
      lambda { @io.read(7, "".freeze) }.should raise_error(TypeError)
    end
  end
end

describe "StringIO#read when passed [length]" do
  before(:each) do
    @io = StringIO.new("example")
  end

  it "reads length bytes from the current position and returns them" do
    @io.pos = 3
    @io.read(4).should == "mple"
  end
  
  it "returns nil when self's position is at the end" do
    @io.pos = 7
    @io.read(10).should be_nil
  end
  
  it "returns an empty String when length is 0" do
    @io.read(0).should == ""
  end
  
  it "reads at most the whole content" do
    @io.read(999).should == "example"
  end
  
  it "correctly updates the position" do
    @io.read(3)
    @io.pos.should eql(3)
    
    @io.read(999)
    @io.pos.should eql(7)
  end
  
  it "tries to convert the passed length Object to an Integer using #to_int" do
    obj = mock("to_int")
    obj.should_receive(:to_int).and_return(7)
    @io.read(obj).should == "example"
  end
  
  it "raises a TypeError when the passed length Object can't be converted to an Integer" do
    lambda { @io.read(Object.new) }.should raise_error(TypeError)
  end
  
  it "raises a TypeError when the passed length is negative" do
    lambda { @io.read(-2) }.should raise_error(ArgumentError)
  end

  ruby_version_is "" ... "1.8.7" do
    it "checks whether the passed buffer Object responds to #to_int" do
      obj = mock('method_missing to_int')
      obj.should_receive(:respond_to?).with(:to_int).and_return(true)
      obj.should_receive(:method_missing).with(:to_int).and_return(7)
      @io.read(obj).should == "example"
    end
  end

  ruby_version_is "1.8.7" do
    it "checks whether the passed buffer Object responds to #to_int (including private methods)" do
      obj = mock('method_missing to_int')
      obj.should_receive(:respond_to?).with(:to_int, true).and_return(true)
      obj.should_receive(:method_missing).with(:to_int).and_return(7)
      @io.read(obj).should == "example"
    end
  end
end

describe "StringIO#read when passed no arguments" do
  before(:each) do
    @io = StringIO.new("example")
  end
  
  it "reads the whole content from the current position" do
    @io.read.should == "example"
    
    @io.pos = 3
    @io.read.should == "mple"
  end
  
  it "correctly updates the current position" do
    @io.read
    @io.pos.should eql(7)
  end
  
  ruby_bug "#", "1.8.7.17" do
    it "returns  when self is at the end" do
      @io.pos = 7
      @io.read.should be_nil
    end
  end
end

describe "StringIO#read when self is not readable" do
  it "raises an IOError" do
    io = StringIO.new("test", "w")
    lambda { io.read }.should raise_error(IOError)

    io = StringIO.new("test")
    io.close_read
    lambda { io.read }.should raise_error(IOError)
  end
end