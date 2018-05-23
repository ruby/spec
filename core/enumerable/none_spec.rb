require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "Enumerable#none?" do
  before :each do
    @empty = EnumerableSpecs::Empty.new
    @enum = EnumerableSpecs::Numerous.new
  end

  it "always returns true on empty enumeration" do
    @empty.none?.should == true
    @empty.none? { true }.should == true
  end

  it "raises an ArgumentError when more than 1 argument is provided" do
    lambda { @enum.none?(1, 2, 3) }.should raise_error(ArgumentError)
    lambda { [].none?(1, 2, 3) }.should raise_error(ArgumentError)
    lambda { {}.none?(1, 2, 3) }.should raise_error(ArgumentError)
  end

  ruby_version_is ""..."2.5" do
    it "raises an ArgumentError when any arguments provided" do
      lambda { @enum.none?(Proc.new {}) }.should raise_error(ArgumentError)
      lambda { @enum.none?(nil) }.should raise_error(ArgumentError)
      lambda { @empty.none?(1) }.should raise_error(ArgumentError)
      lambda { @enum.none?(1) {} }.should raise_error(ArgumentError)
    end
  end

  it "does not hide exceptions out of #each" do
    lambda {
      EnumerableSpecs::ThrowingEach.new.none?
    }.should raise_error(RuntimeError)

    lambda {
      EnumerableSpecs::ThrowingEach.new.none? { false }
    }.should raise_error(RuntimeError)
  end

  describe "with no block" do
    it "returns true if none of the elements in self are true" do
      e = EnumerableSpecs::Numerous.new(false, nil, false)
      e.none?.should be_true
    end

    it "returns false if at least one of the elements in self are true" do
      e = EnumerableSpecs::Numerous.new(false, nil, true, false)
      e.none?.should be_false
    end

    it "gathers whole arrays as elements when each yields multiple" do
      # This spec doesn't spec what it says it does
      multi = EnumerableSpecs::YieldsMultiWithFalse.new
      multi.none?.should be_false
    end
  end

  describe "with a block" do
    before :each do
      @e = EnumerableSpecs::Numerous.new(1,1,2,3,4)
    end

    it "passes each element to the block in turn until it returns true" do
      acc = []
      @e.none? {|e| acc << e; false }
      acc.should == [1,1,2,3,4]
    end

    it "stops passing elements to the block when it returns true" do
      acc = []
      @e.none? {|e| acc << e; e == 3 ? true : false }
      acc.should == [1,1,2,3]
    end

    it "returns true if the block never returns true" do
      @e.none? {|e| false }.should be_true
    end

    it "returns false if the block ever returns true" do
      @e.none? {|e| e == 3 ? true : false }.should be_false
    end

    it "does not hide exceptions out of the block" do
      lambda {
        @enum.none? { raise "from block" }
      }.should raise_error(RuntimeError)
    end

    it "gathers initial args as elements when each yields multiple" do
      multi = EnumerableSpecs::YieldsMulti.new
      yielded = []
      multi.none? { |e| yielded << e; false }
      yielded.should == [1, 3, 6]
    end

    it "yields multiple arguments when each yields multiple" do
      multi = EnumerableSpecs::YieldsMulti.new
      yielded = []
      multi.none? { |*args| yielded << args; false }
      yielded.should == [[1, 2], [3, 4, 5], [6, 7, 8, 9]]
    end
  end

  ruby_version_is "2.5" do
    describe "given a pattern argument" do
      # This spec should be replaced by more extensive ones
      it "returns true iff none match that pattern" do
        EnumerableSpecs::Numerous.new.none?(Float).should == true
        [nil, false, true].none?(NilClass).should == false
      end
    end
  end
end
