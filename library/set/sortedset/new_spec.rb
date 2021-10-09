require_relative '../../../spec_helper'
require 'set'

ruby_version_is "3.0" do
  describe "SortedSet.new" do
    it "throws error including message that it has been extracted" do
      -> {
        SortedSet.new
      }.should raise_error(RuntimeError) { |e|
        e.message.should.include?("The `SortedSet` class has been extracted from the `set` library")
      }
    end
  end
end

ruby_version_is ""..."3.0" do
  describe "SortedSet.new" do
    it "returns an instance of SortedSet" do
      SortedSet.new.should be_an_instance_of(SortedSet)
    end
  end
end
