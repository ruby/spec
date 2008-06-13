require File.dirname(__FILE__) + '/../../spec_helper'
require "stringio"
require File.dirname(__FILE__) + '/shared/read'

describe "StringIO#read" do
  it_behaves_like :stringio_read, :read
end

describe "StringIO#read when passed [length]" do
  before(:each) do
    @io = StringIO.new("example")
  end
  
  it "returns nil when self's position is at the end" do
    @io.pos = 7
    @io.read(10).should be_nil
  end

  it "returns an empty String when length is 0" do
    @io.read(0).should == ""
  end
end

describe "StringIO#read when passed no arguments" do
  ruby_bug "#", "1.8.7.17" do
    it "returns nil when self is at the end" do
      @io.pos = 7
      @io.send(cmd).should be_nil
    end
  end
end
