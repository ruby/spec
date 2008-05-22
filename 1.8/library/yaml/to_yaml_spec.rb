require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/common'

describe "Object#to_yaml" do
  it "returns the YAML representation of a String" do
    "I love Ruby".to_yaml.should == "--- I love Ruby\n"
  end

  it "returns the YAML representation of a Symbol" do
    :symbol.to_yaml.should ==  "--- :symbol\n"
  end

  it "returns the YAML representation of an Array" do
    %w( 30 ruby maz irb 99 ).to_yaml.should == "--- \n- \"30\"\n- ruby\n- maz\n- irb\n- \"99\"\n"
  end

  it "returns the YAML representation of a Struct" do
    Person = Struct.new(:name, :gender)
    Person.new("Jane", "female").to_yaml.should == "--- !ruby/struct:Person \nname: Jane\ngender: female\n"
  end
end

