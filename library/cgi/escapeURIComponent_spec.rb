require_relative '../../spec_helper'
require 'cgi'

ruby_version_is "3.2" do
  describe "CGI.escapeURIComponent" do
    it "escapes whitespace" do
      str = "&<>\" \xE3\x82\x86\xE3\x82\x93\xE3\x82\x86\xE3\x82\x93"
      CGI.escapeURIComponent(str).should == '%26%3C%3E%22%20%E3%82%86%E3%82%93%E3%82%86%E3%82%93'
    end

    it "does not escape with unreserved characters" do
      str = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
      CGI.escapeURIComponent(str).should == "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
    end

    it "supports String with invalid encoding" do
      str = "\xC0\<\<".force_encoding("UTF-8")
      CGI.escapeURIComponent(str).should == "%C0%3C%3C"
    end

    it "raises a TypeError with nil" do
      -> {
        CGI.escapeURIComponent(nil)
      }.should raise_error(TypeError) { |e|
        e.message.should.include?("no implicit conversion of nil into String")
        e.cause.should == nil
      }
    end

    it "encodes empty string" do
      CGI.escapeURIComponent("").should == ""
    end

    it "encodes single whitespace" do
      CGI.escapeURIComponent(" ").should == "%20"
    end

    it "encodes double whitespace" do
      CGI.escapeURIComponent("  ").should == "%20%20"
    end

    it "preserves encoding" do
      CGI.escapeURIComponent("whatever".force_encoding("ASCII-8BIT")).encoding.should == Encoding::ASCII_8BIT
    end

    it "uses implicit type conversion" do
      c = Class.new do
        def to_str
          "a b"
        end
      end
      o = c.new
      CGI.escapeURIComponent(o).should == "a%20b"
    end
  end
end
