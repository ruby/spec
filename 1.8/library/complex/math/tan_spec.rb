require File.dirname(__FILE__) + '/../../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'
require 'complex'

describe "Math#tan" do
  before(:each) do
    @im = IncludesMath.new
  end
  
  it "should be private" do
    IncludesMath.private_instance_methods.should include("tan")
  end

  it "returns the tangent of the argument" do
    @im.send(:tan, 0.0).should == 0.0
    @im.send(:tan, -0.0).should == -0.0
    @im.send(:tan, 4.22).should be_close(1.86406937682395, TOLERANCE)
    @im.send(:tan, -9.65).should be_close(-0.229109052606441, TOLERANCE)
    
    @im.send(:tan, Complex(0, Math::PI)).should be_close(Complex(0.0, 0.99627207622075), TOLERANCE)
    @im.send(:tan, Complex(3, 4)).should be_close(Complex(-0.000187346204629452, 0.999355987381473), TOLERANCE)
  end
end

describe "Math#tan!" do
  before(:each) do
    @im = IncludesMath.new
  end
  
  it "should be private" do
    IncludesMath.private_instance_methods.should include("tan!")
  end

  it "returns the tangent of the argument" do
    @im.send(:tan!, 0.0).should == 0.0
    @im.send(:tan!, -0.0).should == -0.0
    @im.send(:tan!, 4.22).should be_close(1.86406937682395, TOLERANCE)
    @im.send(:tan!, -9.65).should be_close(-0.229109052606441, TOLERANCE)
  end
  
  it "raises a TypeError when passed a Complex number" do
    lambda { @im.send(:tan!, Complex(4, 5)) }.should raise_error(TypeError)
  end
end

describe "Math.tan" do
  it "returns the tangent of the argument" do
    Math.tan(0.0).should == 0.0
    Math.tan(-0.0).should == -0.0
    Math.tan(4.22).should be_close(1.86406937682395, TOLERANCE)
    Math.tan(-9.65).should be_close(-0.229109052606441, TOLERANCE)
    
    Math.tan(Complex(0, Math::PI)).should be_close(Complex(0.0, 0.99627207622075), TOLERANCE)
    Math.tan(Complex(3, 4)).should be_close(Complex(-0.000187346204629452, 0.999355987381473), TOLERANCE)
  end
end

describe "Math.tan!" do
  it "returns the tangent of the argument" do
    Math.tan!(0.0).should == 0.0
    Math.tan!(-0.0).should == -0.0
    Math.tan!(4.22).should be_close(1.86406937682395, TOLERANCE)
    Math.tan!(-9.65).should be_close(-0.229109052606441, TOLERANCE)
  end
  
  it "raises a TypeError when passed a Complex number" do
    lambda { Math.tan!(Complex(4, 5)) }.should raise_error(TypeError)
  end
end
