require_relative '../../spec_helper'

ruby_version_is "3.2" do
  describe "Enumerator.product" do
    it "creates an infinite enumerator" do
      enum = Enumerator.product(1.., ["A", "B"])
      enum.take(5).should == [[1, "A"], [1, "B"], [2, "A"], [2, "B"], [3, "A"]]
    end

    it "accepts a block" do
      elems = []
      enum = Enumerator.product(1..2, ["X", "Y"]) { elems << _1 }

      elems.should == [[1, "X"], [1, "Y"], [2, "X"], [2, "Y"]]
    end

    it "cos tam" do
      enum = Enumerator.product(1.., Enumerator.new { |y| y << "X" << "Y" })
      enum.take(4).should == [[1, "X"], [1, "Y"], [2, "X"], [2, "Y"]]
    end
  end
end
