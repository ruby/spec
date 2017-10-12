require File.expand_path('../../../spec_helper', __FILE__)

describe "Fixnum" do
  it "is deprecated and unified into Integer"
    Fixnum.should == Integer
  end
end
