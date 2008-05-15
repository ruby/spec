require File.dirname(__FILE__) + '/../../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'
require 'complex'

describe "Math#tanh" do
  before(:each) do
    @im = IncludesMath.new
  end
  
  it "should be private" do
    IncludesMath.private_instance_methods.should include("tanh")
  end

  it "returns the hyperbolic tangent of the argument" do
    @im.send(:tanh, 0.0).should == 0.0
    @im.send(:tanh, -0.0).should == -0.0
    @im.send(:tanh, 1.0/0.0).should == 1.0
    @im.send(:tanh, 1.0/-0.0).should == -1.0
    @im.send(:tanh, 2.5).should be_close(0.98661429815143, TOLERANCE)
    @im.send(:tanh, -4.892).should be_close(-0.999887314427707, TOLERANCE)

    @im.send(:tanh, Complex(0, Math::PI)).should be_close(Complex(0.0, -1.22464679914735e-16), TOLERANCE)
    @im.send(:tanh, Complex(3, 4)).should be_close(Complex(1.00070953606723, 0.00490825806749599), TOLERANCE)
  end
end

describe "Math#tanh!" do
  before(:each) do
    @im = IncludesMath.new
  end
  
  it "should be private" do
    IncludesMath.private_instance_methods.should include("tanh!")
  end

  it "returns the hyperbolic tangent of the argument" do
    @im.send(:tanh!, 0.0).should == 0.0
    @im.send(:tanh!, -0.0).should == -0.0
    @im.send(:tanh!, 1.0/0.0).should == 1.0
    @im.send(:tanh!, 1.0/-0.0).should == -1.0
    @im.send(:tanh!, 2.5).should be_close(0.98661429815143, TOLERANCE)
    @im.send(:tanh!, -4.892).should be_close(-0.999887314427707, TOLERANCE)
  end

  it "raises a TypeError when passed a Complex number" do
    lambda { @im.send(:tanh!, Complex(4, 5)) }.should raise_error(TypeError)
  end
end

describe "Math.tanh" do
  it "returns the hyperbolic tangent of the argument" do
    Math.tanh(0.0).should == 0.0
    Math.tanh(-0.0).should == -0.0
    Math.tanh(1.0/0.0).should == 1.0
    Math.tanh(1.0/-0.0).should == -1.0
    Math.tanh(2.5).should be_close(0.98661429815143, TOLERANCE)
    Math.tanh(-4.892).should be_close(-0.999887314427707, TOLERANCE)

    Math.tanh(Complex(0, Math::PI)).should be_close(Complex(0.0, -1.22464679914735e-16), TOLERANCE)
    Math.tanh(Complex(3, 4)).should be_close(Complex(1.00070953606723, 0.00490825806749599), TOLERANCE)
  end
end

describe "Math.tanh!" do
  it "returns the hyperbolic tangent of the argument" do
    Math.tanh!(0.0).should == 0.0
    Math.tanh!(-0.0).should == -0.0
    Math.tanh!(1.0/0.0).should == 1.0
    Math.tanh!(1.0/-0.0).should == -1.0
    Math.tanh!(2.5).should be_close(0.98661429815143, TOLERANCE)
    Math.tanh!(-4.892).should be_close(-0.999887314427707, TOLERANCE)
  end

  it "raises a TypeError when passed a Complex number" do
    lambda { Math.tanh!(Complex(4, 5)) }.should raise_error(TypeError)
  end
end
