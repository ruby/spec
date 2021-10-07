require_relative '../../../spec_helper'
require 'set'

describe :set_join, shared: true do
  before :each do
    @set = Set[:a, :b, :c]
  end

  it "returns a new string formed by joining elements after conversion" do
    @set.send(@method).should == "abc"
  end

  it "does not separate elements when the passed separator is nil" do
    @set.send(@method, nil).should == "abc"
  end

  it "returns a string formed by concatenating each element separated by the separator" do
    @set.send(@method, ' | ').should == "a | b | c"
  end

  it "calls #to_a to convert the Set in to an Array" do
    @set.should_receive(:to_a).and_return([:a, :b, :c])
    @set.send(@method).should == "abc"
  end
end
