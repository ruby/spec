require File.expand_path('../../../../spec_helper', __FILE__)
require 'mathn'

describe "Prime::instance" do
  it "returns an instance of Prime number" do
    Prime.instance.should be_kind_of(Prime)
  end
  
  it "raises a TypeError when is called with some arguments" do
    lambda { Prime.instance(1) }.should raise_error(ArgumentError)
  end  
end
