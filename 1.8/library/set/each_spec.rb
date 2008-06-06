require File.dirname(__FILE__) + '/../../spec_helper'
require 'set'

describe "Set#each" do
  before(:each) do
    @set = Set[1, 2, 3]
  end
  
  it "yields each Object in self" do
    ret = []
    @set.each do { |x| ret << x }
    ret.sort.should == [1, 2, 3]
  end
  
  it "returns self" do
    @set.each do { |x| x }.should equal(@set)
  end
  
  it "raises a LocalJumpError when not passed a block" do
    lambda { @set.each }.should raise_error(LocalJumpError)
  end
end