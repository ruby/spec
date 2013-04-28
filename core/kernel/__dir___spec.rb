require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is "2.0" do
  describe "Kernel#__dir__" do
    it "returns the name of the directory containing the currently-executing file" do
      __dir__.should == File.dirname(__FILE__)
    end
  end
end
