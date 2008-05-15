require File.dirname(__FILE__) + '/../../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'
require 'complex'

describe "Math#cosh" do
  before(:each) do
    @im = IncludesMath.new
  end
  
  it "should be private" do
    IncludesMath.private_instance_methods.should include("cosh")
  end
  
  it "returns the hyperbolic cosine of the passed argument" do
    @im.send(:cosh, 0.0).should == 1.0
    @im.send(:cosh, -0.0).should == 1.0
    @im.send(:cosh, 1.5).should be_close(2.35240961524325, TOLERANCE)
    @im.send(:cosh, -2.99).should be_close(9.96798496414416, TOLERANCE)

    @im.send(:cosh, Complex(0, Math::PI)).should be_close(Complex(-1.0, 0.0), TOLERANCE)
    @im.send(:cosh, Complex(3, 4)).should be_close(Complex(-6.58066304055116, -7.58155274274654), TOLERANCE)
  end
end

describe "Math#cosh!" do
  before(:each) do
    @im = IncludesMath.new
  end
  
  it "should be private" do
    IncludesMath.private_instance_methods.should include("cosh!")
  end

  it "returns the hyperbolic cosine of the passed argument" do
    @im.send(:cosh!, 0.0).should == 1.0
    @im.send(:cosh!, -0.0).should == 1.0
    @im.send(:cosh!, 1.5).should be_close(2.35240961524325, TOLERANCE)
    @im.send(:cosh!, -2.99).should be_close(9.96798496414416, TOLERANCE)
  end

  it "raises a TypeError when passed a Complex number" do
    lambda { @im.send(:cosh!, Complex(4, 5)) }.should raise_error(TypeError)
  end
end

describe "Math.cosh" do
  it "returns the hyperbolic cosine of the passed argument" do
    Math.cosh(0.0).should == 1.0
    Math.cosh(-0.0).should == 1.0
    Math.cosh(1.5).should be_close(2.35240961524325, TOLERANCE)
    Math.cosh(-2.99).should be_close(9.96798496414416, TOLERANCE)

    Math.cosh(Complex(0, Math::PI)).should be_close(Complex(-1.0, 0.0), TOLERANCE)
    Math.cosh(Complex(3, 4)).should be_close(Complex(-6.58066304055116, -7.58155274274654), TOLERANCE)
  end
end

describe "Math.cosh!" do
  it "returns the hyperbolic cosine of the passed argument" do
    Math.cosh!(0.0).should == 1.0
    Math.cosh!(-0.0).should == 1.0
    Math.cosh!(1.5).should be_close(2.35240961524325, TOLERANCE)
    Math.cosh!(-2.99).should be_close(9.96798496414416, TOLERANCE)
  end

  it "raises a TypeError when passed a Complex number" do
    lambda { Math.cosh!(Complex(4, 5)) }.should raise_error(TypeError)
  end
end
