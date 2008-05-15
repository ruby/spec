require File.dirname(__FILE__) + '/../../spec_helper'

describe "Numeric#coerce" do
  it "should be provided" do
    Numeric.instance_methods.should include("coerce")
  end

  it "returns an array containing other and self as Fixnums when given an Fixnum" do
    result = 1.coerce(20)
    result.should == [20, 1]
    result.first.should be_kind_of(Fixnum)
    result.last.should be_kind_of(Fixnum)
  end
  
  it "returns an array containing other and self as Floats when given a String" do
    result = 1.coerce("10")
    result.should == [10.0, 1.0]
    result.first.should be_kind_of(Float)
    result.last.should be_kind_of(Float)
  end

  not_compliant_on :rubinius do
    it "returns an array containing other and self as Floats when given a Bignum" do
      result = 1.coerce(bignum_value)
      result.should == [bignum_value.to_f, 1.0]
      result.first.should be_kind_of(Float)
      result.last.should be_kind_of(Float)
    end
  end
  
  it "raises a TypeError when other can't be coerced" do
    lambda { 10.coerce(nil)   }.should raise_error(TypeError)
    lambda { 10.coerce(false) }.should raise_error(TypeError)    
  end
  
  it "raises an ArgumentError when other can't be converted to Float" do
    lambda { 10.coerce("test") }.should raise_error(ArgumentError)
  end
end