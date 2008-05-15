require File.dirname(__FILE__) + '/../../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'
require 'complex'

describe "Math#log" do
  before(:each) do
    @im = IncludesMath.new
  end
  
  it "should be private" do
    IncludesMath.private_instance_methods.should include("log")
  end

  it "returns the natural logarithm of the passed argument" do 
    @im.send(:log, 0.0001).should be_close(-9.21034037197618, TOLERANCE)
    @im.send(:log, 0.000000000001e-15).should be_close(-62.1697975108392, TOLERANCE)
    @im.send(:log, 1).should be_close(0.0, TOLERANCE)
    @im.send(:log, 10).should be_close( 2.30258509299405, TOLERANCE)
    @im.send(:log, 10e15).should be_close(36.8413614879047, TOLERANCE)
    
    @im.send(:log, Complex(3, 4)).should be_close(Complex(1.6094379124341, 0.927295218001612), TOLERANCE)
    @im.send(:log, Complex(-3, 4)).should be_close(Complex(1.6094379124341, 2.21429743558818), TOLERANCE)
  end
  
  it "returns the natural logarithm for negative numbers as a Complex number" do
    @im.send(:log, -10).should be_close(Complex(2.30258509299405, 3.14159265358979), TOLERANCE)
    @im.send(:log, -20).should be_close(Complex(2.99573227355399, 3.14159265358979), TOLERANCE)
  end
end

describe "Math#log!" do
  before(:each) do
    @im = IncludesMath.new
  end
  
  it "should be private" do
    IncludesMath.private_instance_methods.should include("log!")
  end

  it "returns the natural logarithm of the argument" do 
    @im.send(:log!, 0.0001).should be_close(-9.21034037197618, TOLERANCE)
    @im.send(:log!, 0.000000000001e-15).should be_close(-62.1697975108392, TOLERANCE)
    @im.send(:log!, 1).should be_close(0.0, TOLERANCE)
    @im.send(:log!, 10).should be_close( 2.30258509299405, TOLERANCE)
    @im.send(:log!, 10e15).should be_close(36.8413614879047, TOLERANCE)
  end
  
  it "raises an Errno::EDOM if the argument is less than 0" do    
    lambda { @im.send(:log!, -10) }.should raise_error(Errno::EDOM)
  end

  it "raises a TypeError when passed a Complex number" do
    lambda { @im.send(:log!, Complex(4, 5)) }.should raise_error(TypeError)
  end
end

describe "Math.log" do
  it "returns the natural logarithm of the passed argument" do 
    Math.log(0.0001).should be_close(-9.21034037197618, TOLERANCE)
    Math.log(0.000000000001e-15).should be_close(-62.1697975108392, TOLERANCE)
    Math.log(1).should be_close(0.0, TOLERANCE)
    Math.log(10).should be_close( 2.30258509299405, TOLERANCE)
    Math.log(10e15).should be_close(36.8413614879047, TOLERANCE)
    
    Math.log(Complex(3, 4)).should be_close(Complex(1.6094379124341, 0.927295218001612), TOLERANCE)
    Math.log(Complex(-3, 4)).should be_close(Complex(1.6094379124341, 2.21429743558818), TOLERANCE)
  end
  
  it "returns the natural logarithm for negative numbers as a Complex number" do
    Math.log(-10).should be_close(Complex(2.30258509299405, 3.14159265358979), TOLERANCE)
    Math.log(-20).should be_close(Complex(2.99573227355399, 3.14159265358979), TOLERANCE)
  end
end

describe "Math.log!" do
  it "returns the natural logarithm of the argument" do 
    Math.log!(0.0001).should be_close(-9.21034037197618, TOLERANCE)
    Math.log!(0.000000000001e-15).should be_close(-62.1697975108392, TOLERANCE)
    Math.log!(1).should be_close(0.0, TOLERANCE)
    Math.log!(10).should be_close( 2.30258509299405, TOLERANCE)
    Math.log!(10e15).should be_close(36.8413614879047, TOLERANCE)
  end
  
  it "raises an Errno::EDOM when the passed argument is negative" do    
    lambda { Math.log!(-10) }.should raise_error(Errno::EDOM)
  end

  it "raises a TypeError when passed a Complex number" do
    lambda { Math.log!(Complex(4, 5)) }.should raise_error(TypeError)
  end
end