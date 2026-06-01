require_relative '../../spec_helper'

describe "Time#iso8601" do
  ruby_version_is "3.4" do
    it "is an alias of Time#xmlschema" do
      Time.instance_method(:iso8601).should == Time.instance_method(:xmlschema)
    end
  end
end
