require File.dirname(__FILE__) + '/../../spec_helper'
require 'stringio'

describe "StringIO.open when passed [Object, Integer]" do
  it "sets the mode based on the passed Integer" do
    io = StringIO.open("example", IO::RDONLY)
    io.closed_read?.should be_false
    io.closed_write?.should be_true

    io = StringIO.open("example", IO::WRONLY)
    io.closed_read?.should be_true
    io.closed_write?.should be_false

    io = StringIO.open("example", IO::RDWR)
    io.closed_read?.should be_false
    io.closed_write?.should be_false
  end

  not_compliant_on :rubinius do
    it "raises a TypeError when passed a frozen string in truncate mode" do
      (str = "example").freeze
      lambda { io = StringIO.open(str, IO::TRUNC) }.should raise_error(TypeError)
    end
  end
end

describe "StringIO.open when passed [Object, Object]" do
  it "tries to convert the passed mode-Object to a String using #to_str" do
    obj = mock('to_str')
    obj.should_receive(:to_str).and_return("r")

    io = StringIO.open("example", obj)
    io.closed_read?.should be_false
    io.closed_write?.should be_true
  end

  ruby_version_is "" ... "1.8.7" do
    it "checks whether the passed mode-Object responds to #to_str" do
      obj = mock('method_missing to_str')
      obj.should_receive(:respond_to?).with(:to_str).and_return(true)
      obj.should_receive(:method_missing).with(:to_str).and_return("r")
      io = StringIO.open("example", obj)
    end
  end

  ruby_version_is "1.8.7" do
    it "checks whether the passed mode-Object responds to #to_str (including private methods)" do
      obj = mock('method_missing to_str')
      obj.should_receive(:respond_to?).with(:to_str, true).and_return(true)
      obj.should_receive(:method_missing).with(:to_str).and_return("r")
      io = StringIO.open("example", obj)
    end
  end
  
  it "sets the mode based on the passed mode-Object" do
    io = StringIO.open("example", "r")
    io.closed_read?.should be_false
    io.closed_write?.should be_true

    io = StringIO.open("example", "w")
    io.closed_read?.should be_true
    io.closed_write?.should be_false

    io = StringIO.open("example", "r+")
    io.closed_read?.should be_false
    io.closed_write?.should be_false

    io = StringIO.open("example", "w+")
    io.closed_read?.should be_false
    io.closed_write?.should be_false

    io = StringIO.open("example", "a")
    io.closed_read?.should be_true
    io.closed_write?.should be_false

    io = StringIO.open("example", "a+")
    io.closed_read?.should be_false
    io.closed_write?.should be_false
  end
  
  # platform_is :windows do
  #   it "can set the mode to binary mode" do
  #     io = StringIO.open("example", "b")
  #     io.
  #   end
  # end
  
  not_compliant_on :rubinius do
    it "raises an Errno::EACCES error when passed a frozen string with a write-mode" do
      (str = "example").freeze
      lambda { io = StringIO.open(str, "r+") }.should raise_error(Errno::EACCES)
      lambda { io = StringIO.open(str, "w") }.should raise_error(Errno::EACCES)
      lambda { io = StringIO.open(str, "a") }.should raise_error(Errno::EACCES)
    end
  end
end

describe "StringIO#initialize when passed [Object]" do
  it "uses the passed Object as the StringIO backend" do
    io = StringIO.open("example")
    io.string.should == "example"
  end
  
  it "sets the mode to read-write" do
    io = StringIO.open("example")
    io.closed_read?.should be_false
    io.closed_write?.should be_false
  end
  
  it "tries to convert the passed Object to a String using #to_str" do
    obj = mock('to_str')
    obj.should_receive(:to_str).and_return("example")
    
    io = StringIO.open(obj)
    io.string.should == "example"
  end

  ruby_version_is "" ... "1.8.7" do
    it "checks whether the passed argument responds to #to_str" do
      obj = mock('method_missing to_str')
      obj.should_receive(:respond_to?).with(:to_str).and_return(true)
      obj.should_receive(:method_missing).with(:to_str).and_return("example")
      
      io = StringIO.open(obj)
      io.string.should == "example"
    end
  end

  ruby_version_is "1.8.7" do
    it "checks whether the passed argument responds to #to_str (including private methods)" do
      obj = mock('method_missing to_str')
      obj.should_receive(:respond_to?).with(:to_str, true).and_return(true)
      obj.should_receive(:method_missing).with(:to_str).and_return("example")
      
      io = StringIO.open(obj)
      io.string.should == "example"
    end
  end
  
  not_compliant_on :rubinius do
    it "automatically sets the mode to read-only when passed a frozen string" do
      (str = "example").freeze
      io = StringIO.open(str)
      io.closed_read?.should be_false
      io.closed_write?.should be_true
    end
  end
end

describe "StringIO.open" do
  it "yields self when passed a block" do
    io_yielded = nil
    io = StringIO.open() { |x| io_yielded = x }
    io.should equal(io_yielded)
  end
end
