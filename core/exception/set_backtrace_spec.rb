require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/common', __FILE__)

describe "Exception#set_backtrace" do
  it "allows the user to set the backtrace to any array" do
    err = RuntimeError.new
    err.set_backtrace ["unhappy"]
    err.backtrace.should == ["unhappy"]
  end

  it "allows the user to set the backtrace from a rescued exception" do
    bt  = ExceptionSpecs::Backtrace.backtrace
    err = RuntimeError.new

    err.set_backtrace bt
    err.backtrace.should == bt
  end

  it "allows the user to set the backtrace to string" do
    err = RuntimeError.new
    err.set_backtrace "unhappy"
    err.backtrace.should == ["unhappy"]
  end

  it "allows the user to set the backtrace to nil" do
    err = RuntimeError.new
    err.set_backtrace nil
    err.backtrace.should be_nil
  end

  it "raises TypeError when argument is not array" do
    err = RuntimeError.new
    lambda { err.set_backtrace 1 }.should raise_error(TypeError)
  end

  it "raises TypeError when argument contains non String element" do
    err = RuntimeError.new
    lambda { err.set_backtrace ["String", 1] }.should raise_error(TypeError)
  end
end
