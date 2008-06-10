require File.dirname(__FILE__) + '/../../../spec_helper'
require 'mathn'

describe "Rational#power2 when passed [Rational]" do
  it "returns Rational(1, 1) when the passed argument is 0" do
    (Rational(3, 4).power2(Rational(0, 3))).should == Rational(1, 1)
    (Rational(-3, 4).power2(Rational(0, 3))).should == Rational(1, 1)
    (Rational(3, -4).power2(Rational(0, 3))).should == Rational(1, 1)
    (Rational(3, 4).power2(Rational(0, -3))).should == Rational(1, 1)
  end

  ruby_bug "#", "1.8.6" do
    it "returns Rational(1, 1) when self is 1" do
      (Rational(1,1).power2(Rational(2, 3))).should == Rational(1, 1)
      (Rational(1,1).power2(Rational(-2, 3))).should == Rational(1, 1)
      (Rational(1,1).power2(Rational(2, -3))).should == Rational(1, 1)
      (Rational(1,1).power2(Rational(-2, -3))).should == Rational(1, 1)
    end
 
    it "returns Rational(0, 1) when self is 0" do
      (Rational(0,1).power2(Rational(2, 3))).should == Rational(0, 1)
      (Rational(0,1).power2(Rational(-2, 3))).should == Rational(0, 1)
      (Rational(0,1).power2(Rational(2, -3))).should == Rational(0, 1)
      (Rational(0,1).power2(Rational(-2, -3))).should == Rational(0, 1)
    end
  end

  ruby_bug "#", "1.8.6" do
    it "returns the Rational value of self raised to the passed argument" do
      (Rational(1, 4).power2(Rational(1, 2))).should == Rational(1, 2)
      (Rational(1, 4).power2(Rational(1, -2))).should == Rational(2, 1)
    end
  end

  it "returns a Complex number when self is negative" do
    (Rational(-1,2).power2(Rational(2, 3))).should be_close(Complex(-0.314980262473718, 0.545561817985861), TOLERANCE)
    (Rational(-1,2).power2(Rational(-2, 3))).should be_close(Complex(-0.793700525984099, -1.3747296369986), TOLERANCE)
    (Rational(-1,2).power2(Rational(2, -3))).should be_close(Complex(-0.793700525984099, -1.3747296369986), TOLERANCE)
  end
end

describe "Rational#power2 when passed [Integer]" do
  it "returns the Rational value of self raised to the passed argument" do
    (Rational(3, 4).power2(4)).should == Rational(81, 256)
    (Rational(3, 4).power2(-4)).should == Rational(256, 81)
    (Rational(-3, 4).power2(-4)).should == Rational(256, 81)
    (Rational(3, -4).power2(-4)).should == Rational(256, 81)
  end
  
  it "returns Rational(1, 1) when the passed argument is 0" do
    (Rational(3, 4).power2(0)).should == Rational(1, 1)
    (Rational(-3, 4).power2(0)).should == Rational(1, 1)
    (Rational(3, -4).power2(0)).should == Rational(1, 1)

    (Rational(bignum_value, 100).power2(0)).should == Rational(1, 1)
    (Rational(3, -bignum_value).power2(0)).should == Rational(1, 1)
  end

  it "raises a NoMethodError when self is a BigNum" do
    lambda { Rational(bignum_value, 2).power2(0) }.should raise_error(NoMethodError)
  end
end

describe "Rational#power2 when passed [Float]" do
  it "returns self converted to Float and raised to the passed argument" do
    (Rational(3, 2).power2(3.0)).should == 3.375
    (Rational(3, 2).power2(1.5)).should be_close(1.83711730708738, TOLERANCE)
    (Rational(3, 2).power2(-1.5)).should be_close(0.544331053951817, TOLERANCE)
  end
  
  it "returns 1.0 when the passed argument is 0" do
    (Rational(3, 4).power2(0.0)).should == 1.0
    (Rational(-3, 4).power2(0.0)).should == 1.0
    (Rational(-3, 4).power2(0.0)).should == 1.0
  end
  
  it "returns NaN if self is negative and the passed argument is not 0" do
    (Rational(-3, 2).power2(1.5)).nan?.should be_true
    (Rational(3, -2).power2(1.5)).nan?.should be_true
    (Rational(3, -2).power2(-1.5)).nan?.should be_true
  end
end
