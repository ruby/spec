require File.dirname(__FILE__) + '/../../spec_helper'

describe "Numeric#zero?" do   
  it "should be provided" do
    Numeric.instance_methods.should include("zero?")
  end

  it "return the vaule if number is different to 0" do 
    0.zero?.should == true
    1.zero?.should == false
  end     
end
