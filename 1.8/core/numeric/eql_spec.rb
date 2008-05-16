require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'

describe "Numeric#eql?" do
  before(:each) do
    @obj = NumericSub.new
  end

  it "returns false if self's and other's types don't match" do
    @obj.eql?(1).should == false
    @obj.eql?(-1.5).should == false
    @obj.eql?(bignum_value).should == false
    @obj.eql?(:sym).should == false
  end
  
  it "returns the result of calling self#== with other when self's and other's types match" do
    other = NumericSub.new
    @obj.should_receive(:==).with(other).and_return("result", nil)
    @obj.eql?(other).should == true
    @obj.eql?(other).should == false
  end
end
