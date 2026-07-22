require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "IO#binmode" do
  before :each do
    @name = tmp("io_binmode.txt")
  end

  after :each do
    @io.close if @io and !@io.closed?
    rm_r @name
  end

  it "returns self" do
    @io = new_io(@name)
    @io.binmode.should.equal?(@io)
  end

  it "raises an IOError on closed stream" do
    -> { IOSpecs.closed_io.binmode }.should.raise(IOError)
  end

  it "sets external encoding to binary" do
    @io = new_io(@name, "w:utf-8")
    @io.binmode
    @io.external_encoding.should == Encoding::BINARY
  end

  it "sets internal encoding to nil" do
    @io = new_io(@name, "w:utf-8:ISO-8859-1")
    @io.binmode
    @io.internal_encoding.should == nil
  end

  it "disables newline conversion for reading" do
    data = "line1\r\nline2\r\n"

    @io = new_io(@name, "wb")
    @io.write(data)
    @io.close

    @io = new_io(@name, "rt")
    @io.set_encoding("utf-8:ISO-8859-1", newline: :universal)
    @io.binmode
    @io.read.should == data
  end
end

describe "IO#binmode?" do
  before :each do
    @filename = tmp("IO_binmode_file")
    @file = File.open(@filename, "w")
    @duped = nil
  end

  after :each do
    @duped.close if @duped
    @file.close
    rm_r @filename
  end

  it "is true after a call to IO#binmode" do
    @file.binmode?.should == false
    @file.binmode
    @file.binmode?.should == true
  end

  it "propagates to dup'ed IO objects" do
    @file.binmode
    @duped = @file.dup
    @duped.binmode?.should == @file.binmode?
  end

  it "raises an IOError on closed stream" do
    -> { IOSpecs.closed_io.binmode? }.should.raise(IOError)
  end
end
