require File.expand_path('../../../../spec_helper', __FILE__)
require 'mathn'

describe "Prime#each with Prime.instance" do
  it "returns the element at the current position and moves forward" do
    p = Prime.instance.each
    p.next.should == 2
    p.next.should == 3
    p.next.next.should == 6
  end
end
