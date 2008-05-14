require File.dirname(__FILE__) + '/../../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'
require 'complex'

describe "Math#acos" do
  before(:each) do
    @im = IncludesMath.new
  end
  
  it "should be private" do
    IncludesMath.private_instance_methods.should include("acos")
  end

  it "returns the arccosine of the passed argument" do 
    @im.send(:acos, 1).should be_close(0.0, TOLERANCE) 
    @im.send(:acos, 0).should be_close(1.5707963267949, TOLERANCE) 
    @im.send(:acos, -1).should be_close(Math::PI,TOLERANCE) 
  end
  
  it "returns a Complex representation if the passed argument is greater than 1.0" do    
    @im.send(:acos, 1.0001).should be_close(Complex(0.0, 0.0141420177752494), TOLERANCE)
  end  
  
  it "returns a Complex representation if the passed argument is less than -1.0" do    
    @im.send(:acos, -1.0001).should be_close(Complex(3.14159265358979, -0.0141420177752495), TOLERANCE)
  end
end

describe "Math#acos!" do
  before(:each) do
    @im = IncludesMath.new
  end

  it "should be private" do
    IncludesMath.private_instance_methods.should include("acos!")
  end

  it "returns the arccosine of the argument" do 
    @im.send(:acos!, 1).should be_close(0.0, TOLERANCE) 
    @im.send(:acos!, 0).should be_close(1.5707963267949, TOLERANCE) 
    @im.send(:acos!, -1).should be_close(Math::PI,TOLERANCE) 
  end

  it "raises an Errno::EDOM if the argument is greater than 1.0" do    
    lambda { @im.send(:acos!, 1.0001) }.should raise_error(Errno::EDOM)
  end  
  
  it "raises an Errno::EDOM if the argument is less than -1.0" do    
    lambda { @im.send(:acos!, -1.0001) }.should raise_error(Errno::EDOM)
  end
end

describe "Math.acos" do
  it "returns the arccosine of the passed argument" do 
    Math.acos(1).should be_close(0.0, TOLERANCE) 
    Math.acos(0).should be_close(1.5707963267949, TOLERANCE) 
    Math.acos(-1).should be_close(Math::PI,TOLERANCE) 
  end
  
  it "returns a Complex representation if the passed argument is greater than 1.0" do    
    Math.acos(1.0001).should be_close(Complex(0.0, 0.0141420177752494), TOLERANCE)
  end  
  
  it "returns a Complex representation if the passed argument is less than -1.0" do    
    Math.acos(-1.0001).should be_close(Complex(3.14159265358979, -0.0141420177752495), TOLERANCE)
  end
end

describe "Math.acos!" do
  it "returns the arccosine of the argument" do 
    Math.acos!(1).should be_close(0.0, TOLERANCE) 
    Math.acos!(0).should be_close(1.5707963267949, TOLERANCE) 
    Math.acos!(-1).should be_close(Math::PI,TOLERANCE) 
  end

  it "raises an Errno::EDOM if the argument is greater than 1.0" do    
    lambda { Math.acos!(1.0001) }.should raise_error(Errno::EDOM)
  end  
  
  it "raises an Errno::EDOM if the argument is less than -1.0" do    
    lambda { Math.acos!(-1.0001) }.should raise_error(Errno::EDOM)
  end
end
