require File.dirname(__FILE__) + '/../../../spec_helper'
require 'cgi'

describe "CGI::TagMaker#nO_element_def" do
  before(:each) do
    @obj = Object.new
    @obj.extend(CGI::TagMaker)
  end

  it "returns code for an element represented by the passed String with optional start/end tags" do
    @obj.nO_element_def("P").should == <<-EOS
          "<P" + attributes.collect{|name, value|
            next unless value
            " " + CGI::escapeHTML(name) +
            if true == value
              ""
            else
              \'="\' + CGI::escapeHTML(value) + \'"\'
            end
          }.to_s + ">" +
          if block_given?
            yield.to_s + "</P>"
          else
            ""
          end
EOS
  end

  it "automatically converts the tag to capital letters" do
    @obj.nO_element_def("p").should == <<-EOS
          "<P" + attributes.collect{|name, value|
            next unless value
            " " + CGI::escapeHTML(name) +
            if true == value
              ""
            else
              \'="\' + CGI::escapeHTML(value) + \'"\'
            end
          }.to_s + ">" +
          if block_given?
            yield.to_s + "</P>"
          else
            ""
          end
EOS
  end

end
