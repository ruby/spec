require File.expand_path('../../../spec_helper', __FILE__)
require 'digest'

describe "Digest.hexencode" do
  before(:each) do
    @string   = 'sample string'
    @encoded  = "73616d706c6520737472696e67"
  end

  it "returns a hex-encoded version of a string" do
    Digest.hexencode('').should == ''
    Digest.hexencode(@string).should == @encoded
  end

  it "returns a hex-encoded version of an object's to_str return value" do
    obj = mock("to_str")
    obj.should_receive(:to_str).and_return(@string)
    Digest.hexencode(obj).should == @encoded
  end

  it "raises TypeError for objects not coercible into String" do
    lambda { Digest.hexencode(nil) }.should raise_error(TypeError)
    lambda { Digest.hexencode(9001) }.should raise_error(TypeError)
  end
end
