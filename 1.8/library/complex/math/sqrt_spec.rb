require File.dirname(__FILE__) + '/../../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'
require 'complex'

describe "Math#sqrt" do
  before(:each) do
    @im = IncludesMath.new
  end
  
  it "should be private" do
    IncludesMath.private_instance_methods.should include("sqrt")
  end
  
  it "returns the square root of the passed argument when it is positive" do
    @im.send(:sqrt, 4).should == 2
    @im.send(:sqrt, 19.36).should == 4.4
  end
  
  it "returns the square root of the passed argument when it is negative" do
    @im.send(:sqrt, -4).should == Complex(0, 2.0)
    @im.send(:sqrt, -19.36).should == Complex(0, 4.4)
  end

  it "returns the square root of the passed argument when it is a Complex number" do
    @im.send(:sqrt, Complex(4, 5)).should be_close(Complex(2.2806933416653, 1.09615788950152), TOLERANCE)
    @im.send(:sqrt, Complex(4, -5)).should be_close(Complex(2.2806933416653, -1.09615788950152), TOLERANCE)
  end
end

describe "Math#sqrt!" do
  before(:each) do
    @im = IncludesMath.new
  end
  
  it "should be private" do
    IncludesMath.private_instance_methods.should include("sqrt!")
  end
  
  it "returns the square root of the passed argument when it is positive" do
    @im.send(:sqrt!, 4).should == 2
    @im.send(:sqrt!, 19.36).should == 4.4
  end
  
  it "raises Errno::EDOM when the passed argument is negative" do
    lambda { @im.send(:sqrt!, -4) }.should raise_error(Errno::EDOM)
    lambda { @im.send(:sqrt!, -19.36) }.should raise_error(Errno::EDOM)
  end

  it "raises a TypeError when given a Complex number" do
    lambda { @im.send(:sqrt!, Complex(4, 5)) }.should raise_error(TypeError)
  end
end

describe "Math.sqrt" do
  it "returns the square root of the passed argument when it is positive" do
    Math.sqrt(4).should == 2
    Math.sqrt(19.36).should == 4.4
  end
  
  it "returns the square root of the passed argument when it is negative" do
    Math.sqrt(-4).should == Complex(0, 2.0)
    Math.sqrt(-19.36).should == Complex(0, 4.4)
  end

  it "returns the square root of the passed argument when it is a Complex number" do
    Math.sqrt(Complex(4, 5)).should be_close(Complex(2.2806933416653, 1.09615788950152), TOLERANCE)
    Math.sqrt(Complex(4, -5)).should be_close(Complex(2.2806933416653, -1.09615788950152), TOLERANCE)
  end
end

describe "Math.sqrt!" do
  it "returns the square root of the passed argument when it is positive" do
    Math.sqrt!(4).should == 2
    Math.sqrt!(19.36).should == 4.4
  end
  
  it "raises Errno::EDOM when the passed argument is negative" do
    lambda { Math.sqrt!(-4) }.should raise_error(Errno::EDOM)
    lambda { Math.sqrt!(-19.36) }.should raise_error(Errno::EDOM)
  end

  it "raises a TypeError when given a Complex number" do
    lambda { Math.sqrt!(Complex(4, 5)) }.should raise_error(TypeError)
  end
end
