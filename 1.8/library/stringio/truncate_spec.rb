require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'

describe "StringIO#truncate" do
  before(:each) do
    @io = StringIO.new('123456789')
  end

  # TODO - ri error - says truncate always returns 0
  it "truncates the underlying string" do
    @io.truncate(4).should == 4
    @io.string.should == '1234'
  end

  it "does not update the position" do
    @io.read(5)
    @io.truncate(3)
    @io.pos.should == 5
  end

  it "raises an Errno::EINVAL if the length argument is negative" do
    lambda { @io.truncate(-1)  }.should raise_error(Errno::EINVAL)
  end

  it "can grow a string to a larger size than the original size" do
    @io.truncate(12)
    @io.string.should == "123456789\000\000\000"
  end
end
