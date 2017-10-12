require File.expand_path('../../../spec_helper', __FILE__)

describe "Bignum" do
  it "is deprecated and unified into Integer"
    Bignum.should == Integer
  end
end
