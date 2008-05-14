require File.dirname(__FILE__) + '/../../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'
require 'complex'

describe "Math#sin" do
  before(:each) do
    @im = IncludesMath.new
  end
  
  it "should be private" do
    IncludesMath.private_instance_methods.should include("cos")
  end

  it "returns the sine of the passed argument expressed in radians" do    
    @im.send(:sin, Math::PI).should be_close(0.0, TOLERANCE)
    @im.send(:sin, 0).should be_close(0.0, TOLERANCE)
    @im.send(:sin, Math::PI/2).should be_close(1.0, TOLERANCE)    
    @im.send(:sin, 3*Math::PI/2).should be_close(-1.0, TOLERANCE)
    @im.send(:sin, 2*Math::PI).should be_close(0.0, TOLERANCE)
    
    @im.send(:sin, Complex(0, Math::PI)).should be_close(Complex(0.0, 11.5487393572577), TOLERANCE)
    @im.send(:sin, Complex(3, 4)).should be_close(Complex(3.85373803791938, -27.0168132580039), TOLERANCE)
  end
end

describe "Math#sin!" do
  before(:each) do
    @im = IncludesMath.new
  end
  
  it "should be private" do
    IncludesMath.private_instance_methods.should include("cos!")
  end

  it "returns the sine of the passed argument expressed in radians" do    
    @im.send(:sin!, Math::PI).should be_close(0.0, TOLERANCE)
    @im.send(:sin!, 0).should be_close(0.0, TOLERANCE)
    @im.send(:sin!, Math::PI/2).should be_close(1.0, TOLERANCE)    
    @im.send(:sin!, 3*Math::PI/2).should be_close(-1.0, TOLERANCE)
    @im.send(:sin!, 2*Math::PI).should be_close(0.0, TOLERANCE)
  end
  
  it "raises a TypeError when passed a Complex number" do
    lambda { @im.send(:sin!, Complex(4, 5)) }.should raise_error(TypeError)
  end
end

describe "Math.sin" do
  it "returns the sine of the passed argument expressed in radians" do    
    Math.sin(Math::PI).should be_close(0.0, TOLERANCE)
    Math.sin(0).should be_close(0.0, TOLERANCE)
    Math.sin(Math::PI/2).should be_close(1.0, TOLERANCE)    
    Math.sin(3*Math::PI/2).should be_close(-1.0, TOLERANCE)
    Math.sin(2*Math::PI).should be_close(0.0, TOLERANCE)
    
    Math.sin(Complex(0, Math::PI)).should be_close(Complex(0.0, 11.5487393572577), TOLERANCE)
    Math.sin(Complex(3, 4)).should be_close(Complex(3.85373803791938, -27.0168132580039), TOLERANCE)
  end
end

describe "Math.sin!" do
  it "returns the sine of the passed argument expressed in radians" do    
    Math.sin(Math::PI).should be_close(0.0, TOLERANCE)
    Math.sin(0).should be_close(0.0, TOLERANCE)
    Math.sin(Math::PI/2).should be_close(1.0, TOLERANCE)    
    Math.sin(3*Math::PI/2).should be_close(-1.0, TOLERANCE)
    Math.sin(2*Math::PI).should be_close(0.0, TOLERANCE)
  end
  
  it "raises a TypeError when passed a Complex number" do
    lambda { Math.sin!(Complex(4, 5)) }.should raise_error(TypeError)
  end
end