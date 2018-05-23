require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "Enumerable#one?" do
  before :each do
    @empty = EnumerableSpecs::Empty.new
    @enum = EnumerableSpecs::Numerous.new
  end

  it "always returns false on empty enumeration" do
    @empty.one?.should == false
    @empty.one? { true }.should == false
  end

  it "raises an ArgumentError when more than 1 argument is provided" do
    lambda { @enum.one?(1, 2, 3) }.should raise_error(ArgumentError)
    lambda { [].one?(1, 2, 3) }.should raise_error(ArgumentError)
    lambda { {}.one?(1, 2, 3) }.should raise_error(ArgumentError)
  end

  ruby_version_is ""..."2.5" do
    it "raises an ArgumentError when any arguments provided" do
      lambda { @enum.one?(Proc.new {}) }.should raise_error(ArgumentError)
      lambda { @enum.one?(nil) }.should raise_error(ArgumentError)
      lambda { @empty.one?(1) }.should raise_error(ArgumentError)
      lambda { @enum.one?(1) {} }.should raise_error(ArgumentError)
    end
  end

  it "does not hide exceptions out of #each" do
    lambda {
      EnumerableSpecs::ThrowingEach.new.one?
    }.should raise_error(RuntimeError)

    lambda {
      EnumerableSpecs::ThrowingEach.new.one? { false }
    }.should raise_error(RuntimeError)
  end

  describe "when passed a block" do
    it "returns true if block returns true once" do
      [:a, :b, :c].one? { |s| s == :a }.should be_true
    end

    it "returns false if the block returns true more than once" do
      [:a, :b, :c].one? { |s| s == :a || s == :b }.should be_false
    end

    it "returns false if the block only returns false" do
      [:a, :b, :c].one? { |s| s == :d }.should be_false
    end

    it "does not hide exceptions out of the block" do
      lambda {
        @enum.one? { raise "from block" }
      }.should raise_error(RuntimeError)
    end

    it "gathers initial args as elements when each yields multiple" do
      # This spec doesn't spec what it says it does
      multi = EnumerableSpecs::YieldsMulti.new
      yielded = []
      multi.one? { |e| yielded << e; false }.should == false
      yielded.should == [1, 3, 6]
    end

    it "yields multiple arguments when each yields multiple" do
      multi = EnumerableSpecs::YieldsMulti.new
      yielded = []
      multi.one? { |*args| yielded << args; false }.should == false
      yielded.should == [[1, 2], [3, 4, 5], [6, 7, 8, 9]]
    end

    ruby_version_is "2.5" do
      describe "given a pattern argument" do
        # This spec should be replaced by more extensive ones
        it "returns true iff none match that pattern" do
          EnumerableSpecs::Numerous.new.one?(Integer).should == false
          [nil, false, true].one?(NilClass).should == true
        end
      end
    end
  end

  describe "when not passed a block" do
    it "returns true if only one element evaluates to true" do
      [false, nil, true].one?.should be_true
    end

    it "returns false if two elements evaluate to true" do
      [false, :value, nil, true].one?.should be_false
    end

    it "returns false if all elements evaluate to false" do
      [false, nil, false].one?.should be_false
    end

    it "gathers whole arrays as elements when each yields multiple" do
      multi = EnumerableSpecs::YieldsMultiWithSingleTrue.new
      multi.one?.should be_false
    end
  end
end
