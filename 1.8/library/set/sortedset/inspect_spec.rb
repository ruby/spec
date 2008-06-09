require File.dirname(__FILE__) + '/../../../spec_helper'
require 'set'

describe "SortedSet#inspect" do
  it "returns a String representation of self" do
    SortedSet[].inspect.should be_kind_of(String)
    SortedSet[1, 2, 3].inspect.should be_kind_of(String)
    SortedSet["1", "2", "3"].inspect.should be_kind_of(String)
  end

  it "correctly handles self-references" do
    (set = SortedSet[]) << set
    set.inspect.should be_kind_of(String)
    set.inspect.should include("#<SortedSet: {...}>")
  end

  ruby_bug "http://redmine.ruby-lang.org/issues/show/118", "1.8.7.7" do
    it "allows nested SortedSets" do
      SortedSet["a", "b", SortedSet["c"]].inspect.should be_kind_of(String)
    end
  end
end
