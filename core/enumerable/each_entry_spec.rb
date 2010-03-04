require File.dirname(__FILE__) + '/../../spec_helper'
require File.expand_path('../fixtures/classes', __FILE__)

ruby_version_is '1.9' do
  describe "Enumerable#each_entry" do
    before :each do
      @enum = EnumerableSpecs::YieldsMixed.new
      @entries = [1, [2], [3,4], [5,6,7], [8,9], nil, []]
    end

    it "yields multiple arguments as an array" do
      acc = []
      @enum.each_entry {|g| acc << g}.should equal(@enum)
      acc.should == @entries
    end

    it "returns an enumerator if no block" do
      e = @enum.each_entry
      e.should be_an_instance_of(enumerator_class)
      e.to_a.should == @entries
    end

    it "raises an Argument error when given arguments" do
      lambda { @enum.each_entry("one").to_a   }.should raise_error(ArgumentError)
      lambda { @enum.each_entry("one"){}.to_a }.should raise_error(ArgumentError)
    end
  end
end