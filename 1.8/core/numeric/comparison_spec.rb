require File.dirname(__FILE__) + '/../../spec_helper'

describe "Numeric#<=>" do
  it "should be provided" do
    Numeric.instance_methods.should include("<=>")
  end
end