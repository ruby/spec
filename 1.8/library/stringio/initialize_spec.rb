require File.dirname(__FILE__) + '/../../spec_helper'
require 'stringio'

describe "StringIO#initialize when passed [Object, Integer]" do
  it "sets the mode based on the passed Integer" do
    io = StringIO.allocate
    io.send(:initialize, "example", IO::RDONLY)
    io.closed_read?.should be_false
    io.closed_write?.should be_true

    io = StringIO.allocate
    io.send(:initialize, "example", IO::WRONLY)
    io.closed_read?.should be_true
    io.closed_write?.should be_false

    io = StringIO.allocate
    io.send(:initialize, "example", IO::RDWR)
    io.closed_read?.should be_false
    io.closed_write?.should be_false
  end

  not_compliant_on :rubinius do
    it "raises a TypeError when passed a frozen string in truncate mode" do
      (str = "example").freeze
      io = StringIO.allocate
      lambda { io.send(:initialize, str, IO::TRUNC) }.should raise_error(TypeError)
    end
  end
end

describe "StringIO#initialize when passed [Object, Object]" do
  before(:each) do
    @io = StringIO.allocate
  end
  
  it "tries to convert the passed mode-Object to a String using #to_str" do
    obj = mock('to_str')
    obj.should_receive(:to_str).and_return("r")
    @io.send(:initialize, "example", obj)
    
    @io.closed_read?.should be_false
    @io.closed_write?.should be_true
  end

  ruby_version_is "" ... "1.8.7" do
    it "checks whether the passed mode-Object responds to #to_str" do
      obj = mock('method_missing to_str')
      obj.should_receive(:respond_to?).with(:to_str).and_return(true)
      obj.should_receive(:method_missing).with(:to_str).and_return("r")
      @io.send(:initialize, "example", obj)
    end
  end

  ruby_version_is "1.8.7" do
    it "checks whether the passed mode-Object responds to #to_str (including private methods)" do
      obj = mock('method_missing to_str')
      obj.should_receive(:respond_to?).with(:to_str, true).and_return(true)
      obj.should_receive(:method_missing).with(:to_str).and_return("r")
      @io.send(:initialize, "example", obj)
    end
  end
  
  it "sets the mode based on the passed mode-Object" do
    io = StringIO.allocate
    io.send(:initialize, "example", "r")
    io.closed_read?.should be_false
    io.closed_write?.should be_true

    io = StringIO.allocate
    io.send(:initialize, "example", "w")
    io.closed_read?.should be_true
    io.closed_write?.should be_false

    io = StringIO.allocate
    io.send(:initialize, "example", "r+")
    io.closed_read?.should be_false
    io.closed_write?.should be_false

    io = StringIO.allocate
    io.send(:initialize, "example", "w+")
    io.closed_read?.should be_false
    io.closed_write?.should be_false

    io = StringIO.allocate
    io.send(:initialize, "example", "a")
    io.closed_read?.should be_true
    io.closed_write?.should be_false

    io = StringIO.allocate
    io.send(:initialize, "example", "a+")
    io.closed_read?.should be_false
    io.closed_write?.should be_false
  end
  
  # platform_is :windows do
  #   it "can set the mode to binary mode" do
  #     io = StringIO.allocate
  #     io.send(:initialize, "example", "b")
  #     io.
  #   end
  # end
end

describe "StringIO#initialize when passed [Object]" do
  before(:each) do
    @io = StringIO.allocate
  end
  
  it "uses the passed Object as the StringIO backend" do
    @io.send(:initialize, "example")
    @io.string.should == "example"
  end
  
  it "sets the mode to read-write" do
    @io.send(:initialize, "example")
    @io.closed_read?.should be_false
    @io.closed_write?.should be_false
  end
  
  it "tries to convert the passed Object to a String using #to_str" do
    obj = mock('to_str')
    obj.should_receive(:to_str).and_return("example")
    @io.send(:initialize, obj)
    @io.string.should == "example"
  end

  ruby_version_is "" ... "1.8.7" do
    it "checks whether the passed argument responds to #to_str" do
      obj = mock('method_missing to_str')
      obj.should_receive(:respond_to?).with(:to_str).and_return(true)
      obj.should_receive(:method_missing).with(:to_str).and_return("example")
      @io.send(:initialize, obj)
      @io.string.should == "example"
    end
  end

  ruby_version_is "1.8.7" do
    it "checks whether the passed argument responds to #to_str (including private methods)" do
      obj = mock('method_missing to_str')
      obj.should_receive(:respond_to?).with(:to_str, true).and_return(true)
      obj.should_receive(:method_missing).with(:to_str).and_return("example")
      @io.send(:initialize, obj)
      @io.string.should == "example"
    end
  end
  
  not_compliant_on :rubinius do
    it "raises an Errno::EACCES error when passed a frozen string with a write-mode" do
      (str = "example").freeze
      lambda { @io.send(:initialize, str, "r+") }.should raise_error(Errno::EACCES)
      lambda { @io.send(:initialize, str, "w") }.should raise_error(Errno::EACCES)
      lambda { @io.send(:initialize, str, "a") }.should raise_error(Errno::EACCES)
    end
    
    it "automatically sets the mode to read-only when passed a frozen string" do
      (str = "example").freeze
      @io.send(:initialize, str)
      @io.closed_read?.should be_false
      @io.closed_write?.should be_true
    end
  end
end

describe "StringIO#initialize" do
  before(:each) do
    @io = StringIO.allocate
  end
  
  it "is private" do
    @io.private_methods.should include("initialize")
  end
  
  it "uses an empty String as the StringIO backend" do
    @io.send(:initialize)
    @io.string.should == ""
  end
  
  it "returns self" do
    @io.send(:initialize).should equal(@io)
  end
end
