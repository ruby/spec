require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'

describe "Array#sample" do
  ruby_version_is "" ... "1.9" do
    it "is not defined" do
      lambda { [].sample }.should raise_error(NoMethodError)
    end
  end

  ruby_version_is "1.9" do
    it "selects a random value from the array" do
      a = [1,2,3,4]
      10.times {
        a.include?(a.sample).should be_true
      }
    end

    it "returns nil for empty arrays" do
      [].sample.should be_nil
    end

    it "raises ArgumentError for a negative sample number" do
      lambda { [1, 2].sample(-1) }.should raise_error(ArgumentError)
    end
  end
end
