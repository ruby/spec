require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)
require File.expand_path('../shared/eql', __FILE__)

# Do not use #should_receive(:eql?) mocks in these specs
# because MSpec uses Hash for mocks and Hash calls #eql?.

describe "Array#eql?" do
  it_behaves_like :array_eql, :eql?

  it "returns false if any corresponding elements are not #eql?" do
    [1, 2, 3, 4].send(@method, [1, 2, 3, 4.0]).should be_false
  end

it "returns false if other is not an Array or subclass" do
    class NotAnArray
      def to_ary
        [1,2,3]
      end
      def ==(other)
	true
      end
    end

    [1,2,3].eql?(NotAnArray.new).should be_false
  end
end
