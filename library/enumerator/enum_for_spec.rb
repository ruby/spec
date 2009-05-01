require File.dirname(__FILE__) + '/../../spec_helper'
require 'enumerator'

describe "#enum_for" do
  it "should be defined in Kernel" do
    Kernel.method_defined?(:enum_for).should be_true
  end

  it "should not require any argument" do
    (1..2).enum_for.to_a.should == [1,2]
  end

  it "should have an alias :to_enum" do
    Kernel.method_defined?(:to_enum).should be_true
  end
end
