require File.dirname(__FILE__) + '/../../spec_helper'
require "stringio"

describe "StringIO#gets when passed [Object]" do
  before(:each) do
    @io = StringIO.new("this>is>an>example")
  end
  
  it "tries to convert the passed Object to a String using #to_str" do
    obj = mock('to_str')
    obj.should_receive(:to_str).and_return(">")
    @io.gets(obj).should == "this>"
  end
  
  it "returns the next paragrah when passed an empty String" do
    io = StringIO.new("this is\n\nan example")
    io.gets("").should == "this is\n"
    io.gets("").should == "an example"
  end
  
  it "returns the entire content when passed nil" do
    io = StringIO.new("this is\n\nan example")
    io.gets(nil).should == "this is\n\nan example"
  end

  ruby_version_is "" ... "1.8.7" do
    it "checks whether the passed argument responds to #to_str" do
      obj = mock('method_missing to_str')
      obj.should_receive(:respond_to?).with(:to_str).and_return(true)
      obj.should_receive(:method_missing).with(:to_str).and_return(">")
      @io.gets(obj).should == "this>"
    end
  end

  ruby_version_is "1.8.7" do
    it "checks whether the passed argument responds to #to_str (including private methods)" do
      obj = mock('method_missing to_str')
      obj.should_receive(:respond_to?).with(:to_str, true).and_return(true)
      obj.should_receive(:method_missing).with(:to_str).and_return(">")
      @io.gets(obj).should == "this>"
    end
  end
end

describe "StringIO#gets" do
  before(:each) do
    @io = StringIO.new("this is\nan example\nfor StringIO#gets")
  end
  
  it "updates self's position" do
    @io.gets
    @io.pos.should eql(8)
    
    @io.gets
    @io.pos.should eql(19)

    @io.gets
    @io.pos.should eql(36)
  end
  
  it "returns the data read till the next occurence of $/ or till eof" do
    @io.gets.should == "this is\n"
    
    begin
      old_sep, $/ = $/, " "
      @io.gets.should == "an "
      @io.gets.should == "example\nfor "
      @io.gets.should == "StringIO#gets"
    ensure
      $/ = old_sep
    end
  end

  it "returns nil if self is at the end" do
    @io.pos = 36
    @io.gets.should be_nil
    @io.gets.should be_nil
  end
end

describe "StringIO#gets when in write-only mode" do
  it "raises an IOError" do
    io = StringIO.new("xyz", "w")
    lambda { io.gets }.should raise_error(IOError)

    io = StringIO.new("xyz")
    io.close_read
    lambda { io.gets }.should raise_error(IOError)
  end
end