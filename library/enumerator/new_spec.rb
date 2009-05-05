require File.dirname(__FILE__) + '/../../spec_helper'
require 'enumerator'

describe "Enumerator.new" do
  it "creates a new custom enumerator with the given object, iterator and arguments" do
    enum = enumerator_class.new(1, :upto, 3)
    enum.should be_kind_of(enumerator_class)
  end

  it "creates a new custom enumerator that responds to #each" do
    enum = enumerator_class.new(1, :upto, 3)
    enum.respond_to?(:each).should == true
  end

  it "creates a new custom enumerator that runs correctly" do
    enumerator_class.new(1, :upto, 3).map{|x|x}.should == [1,2,3]
  end
  
  it "aliases the second argument to :each" do
    enumerator_class.new(1..2).to_a.should == enumerator_class.new(1..2, :each).to_a
  end
end
