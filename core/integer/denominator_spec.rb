require File.dirname(__FILE__) + '/../../spec_helper'

describe "Integer#denominator" do
  ruby_version_is "1.9" do
    it "always returns 1" do
      20.denominator.should == 1
      0.denominator.should == 1
      389877777262.denominator.should == 1
    end
  end
end
