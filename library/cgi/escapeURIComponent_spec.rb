require_relative '../../spec_helper'
require 'cgi'

describe "CGI.escapeURIComponent" do
  ruby_version_is "3.2" do
    it "escapes whitespace" do
      str = "&<>\" \xE3\x82\x86\xE3\x82\x93\xE3\x82\x86\xE3\x82\x93"
      CGI.escapeURIComponent(str).should == '%26%3C%3E%22%20%E3%82%86%E3%82%93%E3%82%86%E3%82%93'
    end

    it "does not escape with unreserved characters" do
      str = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
      CGI.escapeURIComponent(str).should == "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
    end

    it "with invalid bytesequence" do
      str = "\xC0\<\<".force_encoding("UTF-8")
      CGI.escapeURIComponent(str).should == "%C0%3C%3C"
    end

    it "nil raises a TypeError" do
      -> { CGI.escapeURIComponent(nil) }.should raise_error(TypeError)
    end

    it "empty string" do
      CGI.escapeURIComponent("").should == ""
    end

    it "single whitespace" do
      CGI.escapeURIComponent(" ").should == "%20"
    end

    it "double whitespace" do
      CGI.escapeURIComponent("  ").should == "%20%20"
    end

    it "preserves encoding" do
      CGI.escapeURIComponent("whatever".force_encoding("ASCII-8BIT")).encoding.should == Encoding::ASCII_8BIT
    end
  end
end
