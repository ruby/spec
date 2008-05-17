require File.dirname(__FILE__) + '/../../spec_helper'

describe "Fixnum.induced_from with [Float]" do
  it "returns a Fixnum when the passed Float is in Fixnum's range" do
    Fixnum.induced_from(2.5).eql?(2).should == true
    Fixnum.induced_from(-3.14).eql?(-3).should == true
    Fixnum.induced_from(10 - TOLERANCE).eql?(9).should == true
    Fixnum.induced_from(TOLERANCE).eql?(0).should == true
  end
  
  it "raises a RangeError when the passed Float is out of Fixnum's range" do
    lambda { Fixnum.induced_from(bignum_value.to_f) }.should raise_error(RangeError)
    lambda { Fixnum.induced_from(-bignum_value.to_f) }.should raise_error(RangeError)
  end
end

describe "Fixnum.induced_from" do
  it "returns the passed argument when passed a Fixnum" do
    Fixnum.induced_from(3).eql?(3).should == true
    Fixnum.induced_from(-10).eql?(-10).should == true
  end
  
  it "tries to convert non-Integers to a Integers using #to_int" do
    obj = mock("Converted to Integer")
    obj.should_receive(:to_int).and_return(10)
    Fixnum.induced_from(obj)
  end
  
  it "raises a TypeError when conversion to Integer returns a Bignum" do
    obj = mock("Not converted to Integer")
    obj.should_receive(:to_int).and_return(bignum_value)
    lambda { Fixnum.induced_from(obj) }.should raise_error(RangeError)
  end
end