require File.dirname(__FILE__) + '/../../spec_helper'

describe "Integer#numerator" do
  ruby_version_is "1.9" do
    it "returns self" do
      1.numerator.should == 1
      39872.numerator.should == 39872
      0.numerator.should == 0
    end
  end
end
