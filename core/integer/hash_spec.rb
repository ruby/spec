require File.expand_path('../../../spec_helper', __FILE__)

describe "Integer#hash" do
  it "is provided" do
    10000.respond_to?(:hash).should == true
  end

  it "is stable" do
    10000.hash.should == 10000.hash
    10000.hash.should_not == 10001.hash
  end
end
