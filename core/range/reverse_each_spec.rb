require_relative '../../spec_helper'

ruby_version_is "3.3" do
  describe "Range#reverse_each" do
    it "works efficiently for very long Ranges of Integers" do
      (1..2**100).reverse_each.take(3).size.should == 3
    end

    it "works for beginless Ranges of Integers" do
      (..5).reverse_each.take(3).should == [5, 4, 3]
    end

    it "works for Ranges of Strings by converting the Range to an Array first" do
      ("a".."z").reverse_each.take(3).should == ["z", "y", "x"]
    end

    it "raises a TypeError for endless Ranges of Integers" do
      -> {
        (1..).reverse_each.take(3)
      }.should raise_error(TypeError, "can't iterate from NilClass")
    end

    it "raises a TypeError for endless Ranges of other objects" do
      -> {
        ("a"..).reverse_each.take(3)
      }.should raise_error(TypeError, "can't iterate from NilClass")
    end
  end
end
