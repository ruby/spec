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

      it "returns index of element when block condition is satisfied" do
        @enum.each { |x| x >= 33 }.should == 2
      end
    end

    it "raises a TypeError when block returns a String" do
      lambda { [1, 2, 3].bsearch_index { "not ok" } }.should raise_error(TypeError)
    end

    it "returns nil when block is empty" do
      [1, 2, 3].bsearch_index {}.should be_nil
    end

    it "returns nil when block returns false" do
      [1, 2, 3].bsearch_index { false }.should be_nil
    end

    context "with a block that calls break" do
      it "returns nil if break is called without a value" do
        ['a', 'b', 'c'].bsearch_index { |v| break }.should be_nil
      end

      it "returns nil if break is called with a nil value" do
        ['a', 'b', 'c'].bsearch_index { |v| break nil }.should be_nil
      end

      it "returns object if break is called with an object" do
        ['a', 'b', 'c'].bsearch_index { |v| break 1234 }.should == 1234
        ['a', 'b', 'c'].bsearch_index { |v| break "hi" }.should == "hi"
        ['a', 'b', 'c'].bsearch_index { |v| break [42] }.should == [42]
        ['a', 'b', 'c'].bsearch_index { |v| break Hash(nil) }.should == {}
      end
    end

    context "minimum mode" do
      before :each do
        @array = [0, 4, 7, 10, 12]
      end

      it "returns index of first element which element is greater or equal to 4" do
        @array.bsearch_index { |x| x >= 4 }.should == 1
      end

      it "returns index of first element which element is greater or equal to 6" do
        @array.bsearch_index { |x| x >= 6 }.should == 2
      end

      it "returns index of first element which element is greater or equal to -1" do
        @array.bsearch_index { |x| x >= -1 }.should == 0
      end

      it "returns nil when block condition does not satisfy" do
        @array.bsearch_index { |x| x >= 100 }.should be_nil
      end
    end

    context "find any mode" do
      before :each do
        @array = [0, 4, 7, 10, 12]
      end

      it "returns the index of any matched elements where element is between 4 <= x < 8" do
        [1, 2].should include(@array.bsearch_index { |x| 1 - x / 4 })
      end

      it "returns the index of any matched elements where element is between 8 <= x < 10" do
        @array.bsearch_index { |x| 4 - x / 2 }.should be_nil
      end

      it "returns nil when block returns a positive number" do
        @array.bsearch_index { |x| 1 }.should be_nil
      end

      it "returns middle element when block returns zero" do
        @array.bsearch_index { |x| 0 }.should == 2
      end

      it "returns nil when block returns a negative number" do
        @array.bsearch_index { |x| -1 }.should be_nil
      end

      context "magnitude doesn't effect the result" do
        it "returns the index of any matched elements where element is between 4n <= xn < 8n, where n is 2**100" do
          [1, 2].should include(@array.bsearch_index { |x| (1 - x / 4) * (2**100) })
        end

        it "returns nil when block returns multiples of 1" do
          @array.bsearch_index { |x| 1 * (2**100) }.should be_nil
        end

        it "returns nil when block returns multiples of -1" do
          @array.bsearch_index { |x| (-1) * (2**100) }.should be_nil
        end
      end

      it "returns the index of any matched elements for which the block yields true" do
        [1, 2].should include(@array.bsearch_index { |x| (2**100).coerce((1 - x / 4) * (2**100)).first })
      end
    end
  end
end
