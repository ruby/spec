require 'rexml/document'
require File.dirname(__FILE__) + '/../../../spec_helper'

# Covers Element#add_attribute, Element#add_attributes, Element#attribute, 
# Element#has_attributes?

describe "REXML::Element#add_attribute" do
  it "adds an attribute" do
    p = REXML::Element.new "Person"
    tony = REXML::Attribute.new("name", "Tony")
    p.add_attribute tony
    p.attributes["name"].should == "Tony"
  end
  
  it "adds an attribute from a string" do
    p = REXML::Element.new "Person"
    p.add_attribute("name", "Tony")
    p.attributes["name"].should == "Tony"
  end

  it "replaces existing attribute with the same name" do
    p = REXML::Element.new "Godfather"
    p.add_attribute("name", "Vito")
    p.add_attribute("name", "Anthony")
    p.attributes["name"].should == "Anthony"
  end
  
  it "returns the attribute added" do
    p = REXML::Element.new "Person"
    tony = REXML::Attribute.new("name", "Tony")
    attr = p.add_attribute tony
    attr.should == tony
  end
end

describe "REXML::Element#add_attributes" do
  it "adds attributes from hash" do
    p = REXML::Element.new "Person"
    attrs = {"name" => "Chris", "age" => "30", "weight" => "170"}
    p.add_attributes attrs
    p.attributes["name"].should == "Chris"
    p.attributes["age"].should == "30"
    p.attributes["weight"].should == "170"
  end

  it "adds attributes from array" do
    p = REXML::Element.new "Person"
    attrs =  [["name", "Chris"], ["weight", "170"], ["age", "30"]]
    p.add_attributes attrs
    p.attributes["name"].should == "Chris"
    p.attributes["age"].should == "30"
    p.attributes["weight"].should == "170"
  end
end

 # TODO: Add a case with a namespace
describe "REXML::Element#attribute" do
  it "returns attribute by name" do
    p = REXML::Element.new "Person"
    a = REXML::Attribute.new ("drink", "coffee")
    p.add_attribute a
    p.attribute("drink").should == a
  end
end

describe "REXML::Element#has_attributes" do
  it "returns true if element has attributes set" do
    p = REXML::Element.new "Person"
    a = REXML::Attribute.new("name", "John")
    p.add_attribute a
    p.has_attributes?.should == true
  end

  it "returns false if element has no attributes set" do
    p = REXML::Element.new "Person"
    a = REXML::Attribute.new("name", "John")
    p.has_attributes?.should == false
  end
end

describe "REXML::Element.attributes" do
  it "returns the Element's Attributes" do
    p = REXML::Element.new "Person"
    a = REXML::Attribute.new("name", "John")
    attrs = REXML::Attributes.new(p)
    attrs.add a
    p.add_attribute a
    p.attributes.should == attrs
  end

  it "returns an empty hash if element has no attributes" do
    REXML::Element.new("Person").attributes.should == {}
  end
end
