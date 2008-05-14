require File.dirname(__FILE__) + '/../../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'
require 'complex'

describe "Math#cos" do
  before(:each) do
    @im = IncludesMath.new
  end

  it "should be private" do
    IncludesMath.private_instance_methods.should include("cos")
  end

  it "returns the cosine of the argument expressed in radians" do    
    @im.send(:cos, Math::PI).should be_close(-1.0, TOLERANCE)
    @im.send(:cos, 0).should be_close(1.0, TOLERANCE)
    @im.send(:cos, Math::PI/2).should be_close(0.0, TOLERANCE)    
    @im.send(:cos, 3*Math::PI/2).should be_close(0.0, TOLERANCE)
    @im.send(:cos, 2*Math::PI).should be_close(1.0, TOLERANCE)
  
    @im.send(:cos, Complex(0, Math::PI)).should be_close(Complex(11.5919532755215, 0.0), TOLERANCE)
    @im.send(:cos, Complex(3, 4)).should be_close(Complex(-27.0349456030742, -3.85115333481178), TOLERANCE)
  end
end

describe "Math#cos!" do
  before(:each) do
    @im = IncludesMath.new
  end

  it "should be private" do
    IncludesMath.private_instance_methods.should include("cos!")
  end

  it "returns the cosine of the argument expressed in radians" do    
    @im.send(:cos!, Math::PI).should be_close(-1.0, TOLERANCE)
    @im.send(:cos!, 0).should be_close(1.0, TOLERANCE)
    @im.send(:cos!, Math::PI/2).should be_close(0.0, TOLERANCE)    
    @im.send(:cos!, 3*Math::PI/2).should be_close(0.0, TOLERANCE)
    @im.send(:cos!, 2*Math::PI).should be_close(1.0, TOLERANCE)
  end  
  
  it "raises a TypeError when passed a Complex number" do    
    lambda { @im.send(:cos!, Complex(3, 4)) }.should raise_error(TypeError)
  end
end

describe "Math.cos" do
  it "returns the cosine of the argument expressed in radians" do    
    Math.cos(Math::PI).should be_close(-1.0, TOLERANCE)
    Math.cos(0).should be_close(1.0, TOLERANCE)
    Math.cos(Math::PI/2).should be_close(0.0, TOLERANCE)    
    Math.cos(3*Math::PI/2).should be_close(0.0, TOLERANCE)
    Math.cos(2*Math::PI).should be_close(1.0, TOLERANCE)
  
    Math.cos(Complex(0, Math::PI)).should be_close(Complex(11.5919532755215, 0.0), TOLERANCE)
    Math.cos(Complex(3, 4)).should be_close(Complex(-27.0349456030742, -3.85115333481178), TOLERANCE)
  end
end

describe "Math.cos!" do
  it "returns the cosine of the argument expressed in radians" do    
    Math.cos!(Math::PI).should be_close(-1.0, TOLERANCE)
    Math.cos!(0).should be_close(1.0, TOLERANCE)
    Math.cos!(Math::PI/2).should be_close(0.0, TOLERANCE)    
    Math.cos!(3*Math::PI/2).should be_close(0.0, TOLERANCE)
    Math.cos!(2*Math::PI).should be_close(1.0, TOLERANCE)
  end  
  
  it "raises a TypeError when passed a Complex number" do    
    lambda { Math.cos!(Complex(3, 4)) }.should raise_error(TypeError)
  end
end