require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

ruby_version_is "1.9" do
  describe "Enumerable#chunk" do
    it "raises an ArgumentError if called without a block" do
      lambda do
        EnumerableSpecs::Numerous.new.chunk
      end.should raise_error(ArgumentError)
    end

    it "returns an Enumerator if given a block" do
      EnumerableSpecs::Numerous.new.chunk {}.should be_an_instance_of(enumerator_class)
    end

    it "yields each element of the Enumerable to the block" do
      yields = []
      EnumerableSpecs::Numerous.new.chunk {|e| yields << e}.to_a
      EnumerableSpecs::Numerous.new.to_a.should == yields
    end

    it "returns an Enumerator of 2-element Arrays" do
      EnumerableSpecs::Numerous.new.chunk {|e| true}.each do |a|
        a.should be_an_instance_of(Array)
        a.size.should == 2
      end
    end

    it "sets the first element of each sub-Array to the return value of the block" do
      EnumerableSpecs::Numerous.new.chunk {|e| -e }.each do |a|
        a.first.should == -a.last.first
      end
    end

    it "sets the last element of each sub-Array to the consecutive values for which the block returned the first element" do
      ret = EnumerableSpecs::Numerous.new(5,5,2,3,4,5,7,1,9).chunk {|e| e >= 5 }.to_a
      ret[0].last.should == [5, 5]
      ret[1].last.should == [2, 3, 4]
      ret[2].last.should == [5, 7]
      ret[3].last.should == [1]
      ret[4].last.should == [9]
    end

    it "drops every nil returned by the block" do
      en = EnumerableSpecs::Numerous.new(1,2,3,4,5,4,3,2,1)
      ret = en.chunk {|e| e > 3 if e > 1}.to_a
      ret[0].last.should == [2, 3]
      ret[1].last.should == [4, 5, 4]
      ret[2].last.should == [3, 2]
    end

    it "drops every :_separator returned by the block" do
      en = EnumerableSpecs::Numerous.new(1,5,0,8,10,0,4,12,0,3,13)
      ret = en.chunk {|e| e != 0 ? e % 2 : :_separator}.to_a
      ret[0].last.should == [1, 5]
      ret[1].last.should == [8, 10]
      ret[2].last.should == [4, 12]
      ret[3].last.should == [3, 13]
    end

    it "treats every :_alone returned by the block as singleton chunk" do
      ret = EnumerableSpecs::Numerous.new(1,2,-1,0,0,5,8,0,0,-6).chunk {|e| e == 0 ? :_alone : e > 0}.to_a
      ret.should == [[true, [1, 2]], [false, [-1]], [:_alone, [0]], [:_alone, [0]],
                     [true, [5, 8]], [:_alone, [0]], [:_alone, [0]], [false, [-6]]]
    end

    it "raises a RuntimeError if passed a symbol beginning with an underscore other than :_alone and :_separator" do
      lambda do
        EnumerableSpecs::Numerous.new(0).chunk {|e| :_foo}.to_a
      end.should raise_error(RuntimeError)
    end

    it "yields an element and the object passed to chunk to a block" do
      e = EnumerableSpecs::Numerous.new(1)
      ret = e.chunk("yield this") { |*x| x }
      ret.first.first.should == [1, "yield this"]
    end

    it "yields only the elements to the block if no argument is passed to #chunk" do
      e = EnumerableSpecs::Numerous.new(1)
      ret = e.chunk { |*x| x }
      ret.first.first.should == [1]
    end

    it "does not yield the object passed to #chunk if it is nil" do
      e = EnumerableSpecs::Numerous.new(1)
      ret = e.chunk(nil) { |*x| x }
      ret.first.first.should == [1]
    end
  end
end
