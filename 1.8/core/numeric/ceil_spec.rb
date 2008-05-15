require File.dirname(__FILE__) + '/../../spec_helper'

describe "Numeric#ceil" do
  it "should be provided" do
    Numeric.instance_methods.should include("ceil")
  end

  it "returns the smallest Integer greater than or equal to self when passed a Fixnum" do
    0.ceil.should == 0
    100.ceil.should == 100
    -100.ceil.should == -100
  end

  it "returns the smallest Integer greater than or equal to self when passed a Float" do
    0.ceil.should == 0.0
    34.56.ceil.should == 35
    -34.56.ceil.should == -34
  end

  it "returns the smallest Integer greater than or equal to self when passed a Bignum" do
    bignum_value.ceil.should == bignum_value
    (-bignum_value).ceil.should == -bignum_value
  end
end
