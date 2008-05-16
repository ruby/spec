require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/shared/divide'

describe "Bignum#/" do
  it_behaves_like(:bignum_divide, :/)

  it "returns self divided by float" do
    (@bignum / 0xffff_ffff.to_f).should be_close(2147483648.5, TOLERANCE)
  end
end
