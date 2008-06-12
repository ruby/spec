require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'

describe "StringIO#string" do
  it "returns the underlying string" do
    io = StringIO.new(str = "hello")
    io.string.should equal(str)
  end
end

describe "StringIO#string=" do
  before(:each) do
    @io = StringIO.new("example\nstring")
  end

  it "changes the underlying string" do
    str = "hello"
    @io.string = str
    @io.string.should equal(str)
  end

  it "resets the position" do
    @io.pos = 1
    @io.string = "other"
    @io.pos.should eql(0)
  end

  it "resets the line number" do
    @io.lineno = 1
    @io.string = "other"
    @io.lineno.should eql(0)
  end
end
