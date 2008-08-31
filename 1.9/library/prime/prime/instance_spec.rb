require File.dirname(__FILE__) + '/../../../spec_helper'
require 'prime'

describe "Prime.instance" do
  it "returns a object representing the set of prime numbers" do
    Prime.instance.class.should == Prime
  end

  it "does not complain anything" do
    lambda { Prime.instance }.should_not complain
  end
   
  it "raises a TypeError when is called with some arguments" do
    lambda { Prime.instance(1) }.should raise_error(ArgumentError)
  end
end
