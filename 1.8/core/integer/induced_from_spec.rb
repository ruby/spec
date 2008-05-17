require File.dirname(__FILE__) + '/../../spec_helper'

describe "Integer.induced_from with [Float]" do
  it "returns a Fixnum when the passed Float is in Fixnum's range" do
    Integer.induced_from(2.5).eql?(2).should == true
    Integer.induced_from(-3.14).eql?(-3).should == true
    Integer.induced_from(10 - TOLERANCE).eql?(9).should == true
    Integer.induced_from(TOLERANCE).eql?(0).should == true
  end
  
  it "returns a Bignum when the passed Float is out of Fixnum's range" do
    Integer.induced_from(bignum_value.to_f).eql?(bignum_value).should == true
    Integer.induced_from(-bignum_value.to_f).eql?(-bignum_value).should == true
  end
end

describe "Integer.induced_from" do
  it "returns the passed argument when passed a Bignum or Fixnum" do
    Integer.induced_from(1).eql?(1).should == true
    Integer.induced_from(-10).eql?(-10).should == true
    Integer.induced_from(bignum_value).eql?(bignum_value).should == true
  end
  
  it "does not try to convert non-Integers to Integers using #to_int" do
    obj = mock("Not converted to Integer")
    obj.should_not_receive(:to_int)
    lambda { Integer.induced_from(obj) }.should raise_error(TypeError)
  end

  it "does not try to convert non-Integers to Integers using #to_i" do
    obj = mock("Not converted to Integer")
    obj.should_not_receive(:to_i)
    lambda { Integer.induced_from(obj) }.should raise_error(TypeError)
  end
  
  it "raises a TypeError when passed a non-Integer" do
    lambda { Integer.induced_from("2") }.should raise_error(TypeError)
    lambda { Integer.induced_from(:symbol) }.should raise_error(TypeError)
    lambda { Integer.induced_from(Object.new) }.should raise_error(TypeError)
  end
end
