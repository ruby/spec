require File.dirname(__FILE__) + '/../../spec_helper'

describe "Numeric#abs" do  
  it "should be provided" do
    Numeric.instance_methods.should include("abs")
  end

  it "returns the absolute value for Fixnums" do      
    0.abs.should == 0 
    100.abs.should == 100
    -100.abs.should == 100
  end
  
  it "returns the absolute value for Floats" do      
    0.0.abs.should == 0.0
    34.56.abs.should == 34.56
    -34.56.abs.should == 34.56 
  end
  
  it "returns the absolute value for Bignums" do      
    2147483648.abs.should == 2147483648
    -2147483648.abs.should == 2147483648
    9223372036854775808.abs.should == 9223372036854775808
    -9223372036854775808.abs.should == 9223372036854775808    
  end 
end