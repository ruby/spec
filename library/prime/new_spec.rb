require File.expand_path('../../../spec_helper', __FILE__)
require 'prime'

describe "Prime.instance" do
  it "returns an object representing the set of prime numbers" do
    Prime.instance.should be_kind_of(Prime)
  end

  it "does not respond to obsolete features" do
    Prime.instance.should_not respond_to(:succ)
    Prime.instance.should_not respond_to(:next)
  end

  it "raises a NoMethodError when new is called" do
    lambda { Prime.new }.should raise_error(NoMethodError)
  end 
  
  it "raises a ArgumentError when is called with some arguments" do
    lambda { Prime.instance(1) }.should raise_error(ArgumentError)
  end
end
