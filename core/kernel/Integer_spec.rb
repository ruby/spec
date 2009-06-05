require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'

describe "Kernel.Integer when given a String" do
  it "does not call #to_i on the given String" do
    (obj = "2").should_not_receive(:to_i)
    Integer(obj).should == 2
    (obj = "0").should_not_receive(:to_i)
    Integer(obj).should == 0
  end
  
  it "ignores whitespaces" do
    Integer("  2  ").should == 2
    Integer("  22222  ").should == 22222
  end
  
  it "raises an ArgumentError if the given String has no valid Integer representation" do
    [ "", "--2", "-+2", "++2", "a2", "2a", "__2",
      " _2", "2__", "2 _", "2 a"].each do |str|
      lambda { Integer(str) }.should raise_error(ArgumentError)
    end
  end
end

describe "Kernel.Integer" do
  it "is a private method" do
    Kernel.should have_private_instance_method(:Integer)
  end
  
  it "calls #to_int if the given object responds to it" do
    obj = mock('1')
    obj.should_receive(:to_int).and_return(1)
    obj.should_not_receive(:to_i)
    
    Integer(obj).should == 1
  end
  
  it "calls to_i to convert any arbitrary argument to an Integer" do
    (obj = mock('7')).should_receive(:to_i).and_return(7)
    Integer(obj).should == 7
  end

  it "raises a TypeError if there is no to_i method on an object" do
    lambda { Integer(mock('x')) }.should raise_error(TypeError)
  end

  it "raises a TypeError if to_i doesn't return an Integer" do
    (obj = mock('ha!')).should_receive(:to_i).and_return("ha!")
    lambda { Integer(obj) }.should raise_error(TypeError)
  end

  ruby_version_is "1.9" do
    it "raises a TypeError when passed nil" do
      lambda { Integer(nil) }.should raise_error(TypeError)
    end
  end
  
  ruby_version_is ""..."1.9" do
    it "returns 0 when passed nil" do
      Integer(nil).should == 0
    end
  end

  it "returns a Fixnum or Bignum object" do
    Integer(2).should be_an_instance_of(Fixnum)
    Integer(9**99).should be_an_instance_of(Bignum)
  end
  
  it "truncates Floats" do
    Integer(3.14).should == 3
    Integer(90.8).should == 90
  end
    
  it "calls to_i on Rationals" do
    Integer(Rational(8,3)).should == 2
    Integer(3.quo(2)).should == 1
  end

  it "passes through Bignums as-is" do
    bignum = 99**99
    bignum.should be_an_instance_of(Bignum)
    Integer(bignum).should == bignum
    Integer(bignum).should be_an_instance_of(Bignum)
  end

  it "passes through Fixnums as-is" do
    fixnum = 99
    fixnum.should be_an_instance_of(Fixnum)
    Integer(fixnum).should == fixnum
    Integer(fixnum).should be_an_instance_of(Fixnum)
  end


  it "raises a FloatDomainError when passed NaN" do
    lambda { Integer(0.0/0.0) }.should raise_error(FloatDomainError)
  end  
end

describe "Kernel#Integer" do
  it "needs to be reviewed for spec completeness"
end
