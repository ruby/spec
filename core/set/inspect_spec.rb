require_relative '../../spec_helper'

describe "Set#inspect" do
  it "is an alias of Set#to_s" do
    Set.instance_method(:inspect).should == Set.instance_method(:to_s)
  end

  ruby_version_is "4.0" do
    it "returns a String representation similar to a literal Array" do
      Set[].inspect.should == "Set[]"
      Set[1, 2, 3].inspect.should == "Set[1, 2, 3]"
      Set["a", :b, nil].inspect.should == 'Set["a", :b, nil]'
    end

    it "correctly handles cyclic-references" do
      set1 = Set[]
      set2 = Set[set1]
      set1 << set2
      set1.inspect.should.include?("Set[...]")
    end
  end

  ruby_version_is ""..."4.0" do
    it "returns a String representation in the #<Set: {...}> format" do
      Set[1, 2, 3].inspect.should == "#<Set: {1, 2, 3}>"
    end
  end
end
