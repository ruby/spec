require File.dirname(__FILE__) + '/../../spec_helper'
require 'set'

describe "Set#inspect" do
  it "returns a human readable representation of self" do
    Set[].inspect.should == "#<Set: {}>"
    Set[nil, false, true].inspect.should == "#<Set: {false, true, nil}>"
    Set[1, 2, 3].inspect.should == "#<Set: {1, 2, 3}>"
    Set["1", "2", "3"].inspect.should == %q{#<Set: {"1", "2", "3"}>}
    Set[:a, "b", Set[?c]].inspect.should == %q{#<Set: {:a, "b", #<Set: {99}>}>}
  end
end
