require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../shared/comparison_coerce', __FILE__)

describe "Integer#<=" do
  ruby_version_is "2.4"..."2.5" do
    it_behaves_like :integer_comparison_coerce_rescue, :<=
  end

  ruby_version_is "2.5" do
    it_behaves_like :integer_comparison_coerce_not_rescue, :<=
  end

  it "returns true if self is less than or equal to other" do
    (2 <= 13).should == true
    (-600 <= -500).should == true

    (5 <= 1).should == false
    (5 <= 5).should == true
    (-2 <= -2).should == true

    (900 <= bignum_value).should == true
    (5 <= 4.999).should == false
  end

  it "raises an ArgumentError when given a non-Integer" do
    lambda { 5 <= "4"       }.should raise_error(ArgumentError)
    lambda { 5 <= mock('x') }.should raise_error(ArgumentError)
  end
end

