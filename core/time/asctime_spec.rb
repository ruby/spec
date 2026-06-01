require_relative '../../spec_helper'

describe "Time#asctime" do
  it "is an alias of Time#ctime" do
    Time.instance_method(:asctime).should == Time.instance_method(:ctime)
  end
end
