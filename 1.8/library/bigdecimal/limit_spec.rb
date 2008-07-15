require File.dirname(__FILE__) + '/../../spec_helper'
require 'bigdecimal'

describe "BigDecimal.limit" do
  it "limits the number of significant digits in newly created BigDecimal" do
    old = BigDecimal.limit
    BigDecimal.limit.should == 0
    BigDecimal.limit(10).should == 0
    BigDecimal.limit.should == 10
    BigDecimal.limit(old)
  end
end