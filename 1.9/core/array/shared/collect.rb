describe :array_collect, :shared => true do
  it "returns a copy of array with each element replaced by the value returned by block" do
    a = ['a', 'b', 'c', 'd']
    b = a.send(@method) { |i| i + '!' }
    b.should == ["a!", "b!", "c!", "d!"]
    b.object_id.should_not == a.object_id
  end

  it "does not return subclass instance" do
    ArraySpecs::MyArray[1, 2, 3].send(@method) { |x| x + 1 }.class.should == Array
  end

  it "does not change self" do
    a = ['a', 'b', 'c', 'd']
    b = a.send(@method) { |i| i + '!' }
    a.should == ['a', 'b', 'c', 'd']
  end

  it "returns the evaluated value of block on broken in the block" do
    a = ['a', 'b', 'c', 'd']
    b = a.send(@method) {|i|
      if i == 'c'
        break 0
      else
        i + '!'
      end
    }
    b.should == 0
  end

  it "returns an enumerator when no block given" do
    a = [1, 2, 3]
    a.send(@method).should be_kind_of(Enumerator)
  end

  it "does not copy tainted status" do
    a = [1, 2, 3]
    a.taint
    a.send(@method){|x| x}.tainted?.should be_false
  end

  it "does not copy untrusted status" do
    a = [1, 2, 3]
    a.untrust
    a.send(@method){|x| x}.untrusted?.should be_false
  end
end

describe :array_collect_b, :shared => true do
  it "replaces each element with the value returned by block" do
    a = [7, 9, 3, 5]
    a.send(@method) { |i| i - 1 }.should equal(a)
    a.should == [6, 8, 2, 4]
  end

  it "returns self" do
    a = [1, 2, 3, 4, 5]
    b = a.send(@method) {|i| i+1 }
    a.object_id.should == b.object_id
  end

  it "returns the evaluated value of block but its contents is partially modified, on broken in the block" do
    a = ['a', 'b', 'c', 'd']
    b = a.send(@method) {|i|
      if i == 'c'
        break 0
      else
        i + '!'
      end
    }
    b.should == 0
    a.should == ['a!', 'b!', 'c', 'd']
  end

  it "returns an enumerator when no block given" do
    a = [1, 2, 3]
    a.send(@method).should be_kind_of(Enumerator)
  end

  it "keeps tainted status" do
    a = [1, 2, 3]
    a.taint
    a.tainted?.should be_true
    a.send(@method){|x| x}
    a.tainted?.should be_true
  end

  it "keeps untrusted status" do
    a = [1, 2, 3]
    a.untrust
    a.send(@method){|x| x}
    a.untrusted?.should be_true
  end

  compliant_on :ruby, :jruby do
    it "raises a RuntimeError on a frozen array" do
      lambda { ArraySpecs.frozen_array.send(@method) {} }.should raise_error(RuntimeError)
    end
  end
end
