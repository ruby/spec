require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'

describe "Array#compact" do
  it "returns a copy of array with all nil elements removed" do
    a = [1, 2, 4]
    a.compact.should == [1, 2, 4]
    a.compact.object_id.should_not == a.object_id

    a = [1, nil, 2, 4]
    a.compact.should == [1, 2, 4]
    a.compact.object_id.should_not == a.object_id

    a = [1, 2, 4, nil]
    a.compact.should == [1, 2, 4]
    a.compact.object_id.should_not == a.object_id

    a = [nil, 1, 2, 4]
    a.compact.should == [1, 2, 4]
    a.compact.object_id.should_not == a.object_id
  end

  it "returns subclass instance for Array subclasses" do
    my_array = ArraySpecs::MyArray[1, 2, 3, nil]
    my_array.compact.class.should == ArraySpecs::MyArray
    my_array.compact.object_id.should_not == my_array.object_id
  end

  it "keeps tainted status even if all elements are removed" do
    a = [nil, nil]
    a.taint
    a.compact.tainted?.should be_true
  end

  it "keeps untrusted status even if all elements are removed" do
    a = [nil, nil]
    a.untrust
    a.compact.untrusted?.should be_true
  end
end

describe "Array#compact!" do
  it "removes all nil elements" do
    a = ['a', nil, 'b', false, 'c']
    a.compact!.should equal(a)
    a.should == ["a", "b", false, "c"]
    a = [nil, 'a', 'b', false, 'c']
    a.compact!.should equal(a)
    a.should == ["a", "b", false, "c"]
    a = ['a', 'b', false, 'c', nil]
    a.compact!.should equal(a)
    a.should == ["a", "b", false, "c"]
  end

  it "returns self if some nil elements are removed" do
    a = ['a', nil, 'b', false, 'c']
    a.compact!.object_id.should == a.object_id
  end
  
  it "returns nil if there are no nil elements to remove" do
    [1, 2, false, 3].compact!.should == nil
  end

  it "keeps tainted status even if all elements are removed" do
    a = [nil, nil]
    a.taint
    a.compact!
    a.tainted?.should be_true
  end

  it "keeps untrusted status even if all elements are removed" do
    a = [nil, nil]
    a.untrust
    a.compact!
    a.untrusted?.should be_true
  end

  compliant_on :ruby, :jruby do
    it "raises a RuntimeError on a frozen array" do
      lambda { ArraySpecs.frozen_array.compact! }.should raise_error(RuntimeError)
    end
  end
end
