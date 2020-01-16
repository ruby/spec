require_relative '../../spec_helper'

ruby_version_is "2.7" do
  describe "Struct#deconstruct_keys" do
    it "returns a hash of attributes" do
      struct = Struct.new(:x, :y)
      s = struct.new(1, 2)

      s.deconstruct_keys([:x, :y]).should == {x: 1, y: 2}
    end

    it "requires one argument" do
      -> {
        Struct.new(:x).new(1).deconstruct_keys
      }.should raise_error(ArgumentError, /wrong number of arguments \(given 0, expected 1\)/)
    end

    it "returns only specified keys" do
      struct = Struct.new(:x, :y, :z)
      s = struct.new(1, 2, 3)

      s.deconstruct_keys([:x, :y]).should == {x: 1, y: 2}
      s.deconstruct_keys([:x]    ).should == {x: 1}
      s.deconstruct_keys([]      ).should == {}
    end

    it "accepts string attribute names" do
      struct = Struct.new(:x, :y)
      s = struct.new(1, 2)

      s.deconstruct_keys(['x', 'y']).should == {'x' => 1, 'y' => 2}
    end

    it "accepts argument position number as well but returns them as keys" do
      struct = Struct.new(:x, :y, :z)
      s = struct.new(10, 20, 30)

      s.deconstruct_keys([0, 1, 2]).should == {0 => 10, 1 => 20, 2 => 30}
      s.deconstruct_keys([0, 1]   ).should == {0 => 10, 1 => 20}
      s.deconstruct_keys([0]      ).should == {0 => 10}
    end

    it "ignores not existing attribute names" do
      struct = Struct.new(:x, :y)
      s = struct.new(1, 2)

      s.deconstruct_keys([:a, :b, :c]).should == {}
    end
  end
end
