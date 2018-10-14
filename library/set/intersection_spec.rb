require_relative '../../spec_helper'
require_relative 'shared/intersection'
require 'set'

describe "Set#intersection" do
  it_behaves_like :set_intersection, :intersection
end

describe "Set#&" do
  it_behaves_like :set_intersection, :&
end

describe "Set#intersect?" do
  it "returns true when two Sets have at least one element in common" do
    Set[1, 2].intersect?(Set[2, 3]).should == true
  end

  it "returns false when two Sets have no element in common" do
    Set[1, 2].intersect?(Set[3, 4]).should == false
  end
end

describe "Set#disjoint?" do
  it "returns false when two Sets have at least one element in common" do
    Set[1, 2].disjoint?(Set[2, 3]).should == false
  end

  it "returns true when two Sets have no element in common" do
    Set[1, 2].disjoint?(Set[3, 4]).should == true
  end
end
