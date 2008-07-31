require File.dirname(__FILE__) + '/../../spec_helper'

describe "IO#<<" do
  it "writes an object to the IO stream" do
    lambda { 
      $stderr << "Oh noes, an error!"
    }.should output_to_fd("Oh noes, an error!", STDERR)
  end

  it "calls #to_s on the object to print it" do
    lambda { 
      $stderr << 1337
    }.should output_to_fd("1337", STDERR)
  end

  it "raises an error if the stream is closed" do
    path = tmp("io-output-spec")
    fd = IO.sysopen(path, "w")
    io = IO.open(fd)
    io.close
    lambda { io << "test" }.should raise_error(IOError)
    File.unlink(path) if File.exists?(path)
  end
end
