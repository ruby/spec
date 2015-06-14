require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../../enumerable/shared/enumeratorized', __FILE__)

ruby_version_is "2.3" do
  describe "Array#bsearch_index" do
    context "when not passed a block" do
      before :each do
        @enum = [1, 2, 42, 100, 666].bsearch_index
      end

      it "returns an Enumerator" do
        @enum.should be_an_instance_of(enumerator_class)
      end

      it "returns nil for #size" do
        @enum.size.should be_nil
      end

      it "returns index of element given condition in block" do
        @enum.each { |x| x >= 33 }.should == 2
      end
    end

    it "raises TypeError when block passed wrong argument" do
      lambda { [1, 2, 3].bsearch_index { "not ok" } }.should raise_error(TypeError)
    end

    it "returns nil when passed empty block" do
      [1, 2, 3].bsearch_index({}).should be_nil
    end

    it "returns nil when passed block with false" do
      [1, 2, 3].bsearch_index({ false }).should be_nil
    end

    context "minimum mode" do
      before :each do
        @array = [0, 4, 7, 10, 12]
      end

      it "x >= 4" do
        @array.bsearch_index { |x| x >= 4 }.should == 1
      end

      it "x >= 6" do
        @array.bsearch_index { |x| x >= 6 }.should == 2
      end

      it "x >= -1" do
        @array.bsearch_index { |x| x >= -1 }.should == 0
      end

      it "x >= 100" do
        @array.bsearch_index { |x| x >= 100 }.should be_nil
      end
    end

    context "find any mode" do
      before :each do
        @array = [0, 4, 7, 10, 12]
      end

      it "1 - x / 4" do
        @array.bsearch_index { |x| 1 - x / 4 }.should == [1, 2]
      end

      it "4 - x / 2" do
        @array.bsearch_index { |x| 4 - x / 2 }.should be_nil
      end

      it "1" do
        @array.bsearch_index { |x| 1 }.should be_nil
      end

      it "-1" do
        @array.bsearch_index { |x| -1 }.should be_nil
      end

      it "(1 - x / 4) * (2**100)" do
        @array.bsearch_index { |x| (1 - x / 4) * (2**100) }.should == [1, 2]
      end

      it "1 * (2**100)" do
        @array.bsearch_index { |x| 1 * (2**100) }.should be_nil
      end

      it "(-1) * (2**100)" do
        @array.bsearch_index { |x| (-1) * (2**100) }.should be_nil
      end

      it "(2**100).coerce((1 - x / 4) * (2**100)).first" do
        @array.bsearch_index { |x| (2**100).coerce((1 - x / 4) * (2**100)).first }
          .should == [1, 2]
      end
    end
  end
end
