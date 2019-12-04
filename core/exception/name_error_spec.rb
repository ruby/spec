require_relative '../../spec_helper'

describe "NameError.new" do
  it "should take optional name argument" do
    NameError.new("msg","name").name.should == "name"
  end

  ruby_version_is "2.6" do
    it "accepts a :receiver keyword argument" do
      receiver = mock("receiver")

      error = NameError.new("msg", :name, receiver: receiver)

      error.receiver.should == receiver
      error.name.should == :name
    end
  end
end
