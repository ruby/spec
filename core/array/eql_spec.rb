require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'
require File.dirname(__FILE__) + '/shared/equal'

# Do not use #should_receive(:eql?) mocks in these specs
# because MSpec uses Hash for mocks and Hash calls #eql?.

describe "Array#eql?" do
  it_behaves_like :array_equal, :eql?

  it "returns false if any corresponding elements are not #eql?" do
    [1, 2, 3, 4].send(@method, [1, 2, 3, 4.0]).should be_false
  end

  it "does not call #to_ary on its argument" do
    obj = mock('to_ary')
    obj.should_not_receive(:to_ary)

    [1, 2, 3].should_not eql(obj)
  end

  it "does not call #to_ary on Array subclasses" do
    ary = ArraySpecs::ToAryArray[5, 6, 7]
    ary.should_not_receive(:to_ary)
    [5, 6, 7].should eql(ary)
  end

  it "ignores array class differences" do
    ArraySpecs::MyArray[1, 2, 3].should eql([1, 2, 3])
    ArraySpecs::MyArray[1, 2, 3].should eql(ArraySpecs::MyArray[1, 2, 3])
    [1, 2, 3].should eql(ArraySpecs::MyArray[1, 2, 3])
  end
end
