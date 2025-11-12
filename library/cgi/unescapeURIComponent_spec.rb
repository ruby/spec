require_relative '../../spec_helper'

ruby_version_is ""..."3.5" do
  require 'cgi'
end
ruby_version_is "3.5" do
  require 'cgi/escape'
end

describe "CGI.unescapeURIComponent" do
  it "unescapes whitespace" do
    string = "%26%3C%3E%22%20%E3%82%86%E3%82%93%E3%82%86%E3%82%93"
    CGI.unescapeURIComponent(string).should == "&<>\" \xE3\x82\x86\xE3\x82\x93\xE3\x82\x86\xE3\x82\x93"
  end

  it "does not unescape with unreserved characters" do
    string = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
    CGI.unescapeURIComponent(string).should == "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
  end

  it "can produce String with invalid encoding" do
    string = CGI.unescapeURIComponent("%C0%3C%3C")
    string.should == "\xC0<<"
    string.encoding.should == Encoding::UTF_8
  end

  it "processes String bytes one by one, not characters" do
    CGI.unescapeURIComponent("%CE%B2").should == "β" # "β" bytes representation is CE B2
  end

  it "raises a TypeError with nil" do
    -> {
      CGI.unescapeURIComponent(nil)
    }.should raise_error(TypeError, 'no implicit conversion of nil into String')
  end

  it "unencodes empty string" do
    CGI.unescapeURIComponent("").should == ""
  end

  it "unencodes single whitespace" do
    CGI.unescapeURIComponent("%20").should == " "
  end

  it "unencodes double whitespace" do
    CGI.unescapeURIComponent("%20%20").should == "  "
  end

  it "does not preserve encoding" do
    string = "whatever".encode("ASCII-8BIT")
    CGI.unescapeURIComponent(string).encoding.should == Encoding::UTF_8
  end

  it "decodes using a specified Encoding" do
    string = CGI.unescapeURIComponent("%D2%3C%3C", "ISO-8859-1")
    string.encoding.should == Encoding::ISO_8859_1
    string.should == "Ò<<".encode("ISO-8859-1")
  end

  it "uses implicit type conversion to String" do
    object = Object.new
    def object.to_str
      "a%20b"
    end

    CGI.unescapeURIComponent(object).should == "a b"
  end
end
