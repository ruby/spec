require File.dirname(__FILE__) + '/../../spec_helper'

describe "Numeric#truncate" do
  it "should be provided" do
    Numeric.instance_methods.should include("truncate")
  end
  
  it "truncates integers " do 
    0.truncate.should == 0.0
    100.truncate.should == 100
    -100.truncate.should == -100
  end  
  
  it "truncates floats " do  
    34.56.truncate.should == 34
    -34.56.truncate.should == -34
  end  
  
  it "truncates two complement " do
    2147483648.truncate.should == 2147483648
    -2147483648.truncate.should == -2147483648
    9223372036854775808.truncate.should == 9223372036854775808 
    -9223372036854775808.truncate.should == -9223372036854775808 
  end 
end
