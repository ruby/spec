require_relative '../../spec_helper'

ruby_version_is "3.4" do
  describe "Warning.categories" do
    it "returns the list of possible warning categories" do
      Warning.categories.sort.should == [:deprecated, :experimental, :performance, :strict_unused_block]
    end
  end
end
