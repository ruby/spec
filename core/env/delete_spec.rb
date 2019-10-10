require_relative '../../spec_helper'

describe "ENV.delete" do
  before :each do
    @saved = ENV["foo"]
  end
  after :each do
    ENV["foo"] = @saved
  end

  it "removes the variable from the environment" do
    ENV["foo"] = "bar"
    ENV.delete("foo")
    ENV["foo"].should == nil
  end

  it "returns the previous value" do
    ENV["foo"] = "bar"
    ENV.delete("foo").should == "bar"
  end

  it "yields the name to the given block if the named environment variable does not exist" do
    ENV.delete("foo")
    ENV.delete("foo") { |name| ScratchPad.record name }
    ScratchPad.recorded.should == "foo"
  end

  it "ignores the given block if the named environment variable exists" do
    ENV["foo"] = "bar"
    ENV.delete("foo") { |name| fail name }.should == "bar"
  end
end
