require File.dirname(__FILE__) + '/../../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'
require 'complex'

describe "Math#sinh" do
  before(:each) do
    @im = IncludesMath.new
  end
  
  it "should be private" do
    IncludesMath.private_instance_methods.should include("sinh")
  end

  it "returns the hyperbolic sin of the argument" do
    @im.send(:sinh, 0.0).should == 0.0
    @im.send(:sinh, -0.0).should == 0.0
    @im.send(:sinh, 1.5).should be_close(2.12927945509482, TOLERANCE)
    @im.send(:sinh, -2.8).should be_close(-8.19191835423591, TOLERANCE)
    
    @im.send(:sinh, Complex(0, Math::PI)).should be_close(Complex(-0.0, 1.22464679914735e-16), TOLERANCE)
    @im.send(:sinh, Complex(3, 4)).should be_close(Complex(-6.548120040911, -7.61923172032141), TOLERANCE)
  end
end

describe "Math#sinh!" do
  before(:each) do
    @im = IncludesMath.new
  end
  
  it "should be private" do
    IncludesMath.private_instance_methods.should include("sinh!")
  end

  it "returns the hyperbolic sin of the argument" do
    @im.send(:sinh!, 0.0).should == 0.0
    @im.send(:sinh!, -0.0).should == 0.0
    @im.send(:sinh!, 1.5).should be_close(2.12927945509482, TOLERANCE)
    @im.send(:sinh!, -2.8).should be_close(-8.19191835423591, TOLERANCE)
  end

  it "raises a TypeError when passed a Complex number" do
    lambda { @im.send(:sinh!, Complex(4, 5)) }.should raise_error(TypeError)
  end
end

describe "Math.sinh" do
  it "returns the hyperbolic sin of the argument" do
    Math.sinh(0.0).should == 0.0
    Math.sinh(-0.0).should == 0.0
    Math.sinh(1.5).should be_close(2.12927945509482, TOLERANCE)
    Math.sinh(-2.8).should be_close(-8.19191835423591, TOLERANCE)
    
    Math.sinh(Complex(0, Math::PI)).should be_close(Complex(-0.0, 1.22464679914735e-16), TOLERANCE)
    Math.sinh(Complex(3, 4)).should be_close(Complex(-6.548120040911, -7.61923172032141), TOLERANCE)
  end
end

describe "Math.sinh!" do
  it "returns the hyperbolic sin of the argument" do
    Math.sinh!(0.0).should == 0.0
    Math.sinh!(-0.0).should == 0.0
    Math.sinh!(1.5).should be_close(2.12927945509482, TOLERANCE)
    Math.sinh!(-2.8).should be_close(-8.19191835423591, TOLERANCE)
  end

  it "raises a TypeError when passed a Complex number" do
    lambda { Math.sinh!(Complex(4, 5)) }.should raise_error(TypeError)
  end
end
