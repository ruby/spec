require_relative '../../spec_helper'

describe "SystemCallError.===" do
  it "returns a generic error for unknown error number" do
    unknown_error_number = Errno.constants.size
    SystemCallError.new('foo', unknown_error_number).should be_an_instance_of(SystemCallError)
  end

  it "returns a specific error for known error number" do
    error = SystemCallError.new('foo', 1)
    error.should_not be_an_instance_of(SystemCallError)
    error.should be_kind_of(SystemCallError)
  end

  it "returns true if messages and errnos same" do
    e0 = SystemCallError.new('foo', 1)
    e1 = SystemCallError.new('foo', 1)
    e0.===(e1).should == true
  end

  it "returns false if messages same and errnos different" do
    e0 = SystemCallError.new('foo', 1)
    e1 = SystemCallError.new('foo', 2)
    e0.===(e1).should == false
  end

  it "returns false if messages different and errnos same" do
    e0 = SystemCallError.new('foo', 1)
    e1 = SystemCallError.new('bar', 1)
    e0.===(e1).should == false
  end

  it "returns false if receiver is generic" do
    unknown_error_number = Errno.constants.size
    e0 = SystemCallError.new('foo', unknown_error_number)
    e1 = SystemCallError.new('foo', 1)
    e1.===(e0).should == false
  end
end
