require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/common'
require File.dirname(__FILE__) + '/fixtures/example_class'

describe "Object#to_yaml" do

  it "returns the YAML representation of an Array object" do
    %w( 30 ruby maz irb 99 ).to_yaml.should == "--- \n- \"30\"\n- ruby\n- maz\n- irb\n- \"99\"\n"
  end

  it "returns the YAML representation of a Class object" do
    FooBar.new("baz").to_yaml.should == "--- !ruby/object:FooBar \nname: baz\n"
  end

  it "returns the YAML representation of a Date object" do
    Date.parse('1997/12/30').to_yaml.should == "--- 1997-12-30\n"
  end

  it "returns the YAML representation of a Float object" do
    @float = 1.2
    @float.should be_kind_of(Float)
    @float.to_yaml.should == "--- 1.2\n"
  end
  
  it "returns the YAML representation of a String object" do
    "I love Ruby".to_yaml.should == "--- I love Ruby\n"
  end

  it "returns the YAML representation of a Struct object" do
    Person = Struct.new(:name, :gender)
    Person.new("Jane", "female").to_yaml.should == "--- !ruby/struct:Person \nname: Jane\ngender: female\n"
  end

  it "returns the YAML representation of a Symbol object" do
    :symbol.to_yaml.should ==  "--- :symbol\n"
  end
end
