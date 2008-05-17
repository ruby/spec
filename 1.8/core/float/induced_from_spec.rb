require File.dirname(__FILE__) + '/../../spec_helper'

describe "Float.induced_from" do
  it "returns the passed argument when passed a Float" do
    Float.induced_from(5.5).eql?(5.5).should == true
    Float.induced_from(-5.5).eql?(-5.5).should == true
    Float.induced_from(TOLERANCE).eql?(TOLERANCE).should == true
  end
  
  it "converts passed Fixnums or Bignums to Floats (using #to_f)" do
    Float.induced_from(5).eql?(5.0).should == true
    Float.induced_from(-5).eql?(-5.0).should == true
    Float.induced_from(0).eql?(0.0).should == true
    
    Float.induced_from(bignum_value).eql?(bignum_value.to_f).should == true
    Float.induced_from(-bignum_value).eql?(-bignum_value.to_f).should == true
  end

  it "does not try to convert non-Integers to a Integers using #to_int" do
    obj = mock("Not converted to Integer")
    obj.should_not_receive(:to_int)
    lambda { Integer.induced_from(obj) }.should raise_error(TypeError)
  end

  it "does not try to convert non-Integers to a Fixnum using #to_f" do
    obj = mock("Not converted to Integer")
    obj.should_not_receive(:to_f)
    lambda { Integer.induced_from(obj) }.should raise_error(TypeError)
  end
  
  it "raises a TypeError when passed a non-Integer" do
    lambda { Integer.induced_from("2") }.should raise_error(TypeError)
    lambda { Integer.induced_from(:symbol) }.should raise_error(TypeError)
    lambda { Integer.induced_from(Object.new) }.should raise_error(TypeError)
  end
end 
