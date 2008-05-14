require File.dirname(__FILE__) + '/../../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'
require 'complex'

describe "Math#exp" do
  before(:each) do
    @im = IncludesMath.new
  end

  it "should be private" do
    IncludesMath.private_instance_methods.should include("exp")
  end

  it "returns the base-e exponential of the passed argument" do
    @im.send(:exp, 0.0).should == 1.0
    @im.send(:exp, -0.0).should == 1.0
    @im.send(:exp, -1.8).should be_close(0.165298888221587, TOLERANCE)
    @im.send(:exp, 1.25).should be_close(3.49034295746184, TOLERANCE)

    @im.send(:exp, Complex(0, 0)).should == Complex(1.0, 0.0)
    @im.send(:exp, Complex(1, 3)).should be_close(Complex(-2.69107861381979, 0.383603953541131), TOLERANCE)
  end
end

describe "Math#exp!" do
  before(:each) do
    @im = IncludesMath.new
  end

  it "should be private" do
    IncludesMath.private_instance_methods.should include("exp!")
  end

  it "returns the base-e exponential of the passed argument" do
    @im.send(:exp!, 0.0).should == 1.0
    @im.send(:exp!, -0.0).should == 1.0
    @im.send(:exp!, -1.8).should be_close(0.165298888221587, TOLERANCE)
    @im.send(:exp!, 1.25).should be_close(3.49034295746184, TOLERANCE)
  end

  it "raises a TypeError when passed a Complex number" do
    lambda { @im.send(:exp!, Complex(1, 3)) }.should raise_error(TypeError)
  end
end

describe "Math.exp" do
  it "returns the base-e exponential of the passed argument" do
    Math.exp(0.0).should == 1.0
    Math.exp(-0.0).should == 1.0
    Math.exp(-1.8).should be_close(0.165298888221587, TOLERANCE)
    Math.exp(1.25).should be_close(3.49034295746184, TOLERANCE)

    Math.exp(Complex(0, 0)).should == Complex(1.0, 0.0)
    Math.exp(Complex(1, 3)).should be_close(Complex(-2.69107861381979, 0.383603953541131), TOLERANCE)
  end
end

describe "Math.exp!" do
  it "returns the base-e exponential of the passed argument" do
    Math.exp!(0.0).should == 1.0
    Math.exp!(-0.0).should == 1.0
    Math.exp!(-1.8).should be_close(0.165298888221587, TOLERANCE)
    Math.exp!(1.25).should be_close(3.49034295746184, TOLERANCE)
  end

  it "raises a TypeError when passed a Complex number" do
    lambda { Math.exp!(Complex(1, 3)) }.should raise_error(TypeError)
  end
end