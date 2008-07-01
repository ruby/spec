require File.dirname(__FILE__) + '/../../../spec_helper'
require 'cgi'

describe "CGI::TagMaker#nOE_element_def" do
  before(:each) do
    @obj = Object.new
    @obj.extend(CGI::TagMaker)
  end

  it "returns code for an empty element represented by the passed String" do
    @obj.nOE_element_def("BR").should == <<-EOS
          "<BR" + attributes.collect{|name, value|
            next unless value
            " " + CGI::escapeHTML(name) +
            if true == value
              ""
            else
              \'="\' + CGI::escapeHTML(value) + \'"\'
            end
          }.to_s + ">"
EOS
  end

  it "automatically converts the tag to capital letters" do
    @obj.nOE_element_def("br").should == <<-EOS
          "<BR" + attributes.collect{|name, value|
            next unless value
            " " + CGI::escapeHTML(name) +
            if true == value
              ""
            else
              \'="\' + CGI::escapeHTML(value) + \'"\'
            end
          }.to_s + ">"
EOS
  end
end