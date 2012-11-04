require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

describe "Array#choice" do
  ruby_version_is "1.8.7"..."1.9" do
    it "returns a value from the array" do
      [4].choice.should eql(4)
    end

    it "returns nil for empty arrays" do
      [].choice.should be_nil
    end
  end
end
