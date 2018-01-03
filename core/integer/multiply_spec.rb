require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../shared/arithmetic_coerce', __FILE__)

describe "Integer#*" do
  ruby_version_is "2.4"..."2.5" do
    it_behaves_like :integer_arithmetic_coerce_rescue, :*
  end

  ruby_version_is "2.5" do
    it_behaves_like :integer_arithmetic_coerce_not_rescue, :*
  end

  it "returns self multiplied by the given Integer" do
    (4923 * 2).should == 9846
    (1342177 * 800).should == 1073741600
    (65536 * 65536).should == 4294967296

    (256 * bignum_value).should == 2361183241434822606848
    (6712 * 0.25).should == 1678.0
  end

  it "raises a TypeError when given a non-Integer" do
    lambda {
      (obj = mock('10')).should_receive(:to_int).any_number_of_times.and_return(10)
      13 * obj
    }.should raise_error(TypeError)
    lambda { 13 * "10"    }.should raise_error(TypeError)
    lambda { 13 * :symbol }.should raise_error(TypeError)
  end
end

