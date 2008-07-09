require File.dirname(__FILE__) + '/../../spec_helper'
require 'rational'

describe "Rational when passed [Integer, Integer]" do
  it "returns a new Rational number" do
    Rational(1, 2).should == Rational.new!(1, 2)
    Rational(-3, -5).should == Rational.new!(-3, -5)
    Rational(bignum_value, 3).should == Rational.new!(bignum_value, 3)
  end
  
  it "automatically reduces the Rational" do
    Rational(2, 4).should == Rational.new!(1, 2)
    Rational(3, 9).should == Rational.new!(1, 3)
  end
end

describe "Rational when passed [Integer]" do
  it "returns a new Rational number with 1 as the denominator" do
    # Guard against the Mathn library
    conflicts_with :Prime do
      Rational(1).should eql(Rational.new!(1, 1))
      Rational(-3).should eql(Rational.new!(-3, 1))
      Rational(bignum_value).should eql(Rational.new!(bignum_value, 1))
    end
  end
  
  it "returns the passed Integer when Rational::Unify is defined" do
    # Guard against the Mathn library
    conflicts_with :Prime do
      begin
        Rational::Unify = true
      
        Rational(1).should eql(1)
        Rational(-3).should eql(-3)
        Rational(bignum_value).should eql(bignum_value)
      ensure
        Rational.send :remove_const, :Unify
      end
    end
  end
end
