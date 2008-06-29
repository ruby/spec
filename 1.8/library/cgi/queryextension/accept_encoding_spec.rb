require File.dirname(__FILE__) + '/../../../spec_helper'
require 'cgi'

describe "CGI::QueryExtension#accept_encoding" do
  before(:each) do
    @cgi = CGI.new
  end
  
  it "returns ENV['HTTP_ACCEPT_ENCODING']" do
    old_value, ENV['HTTP_ACCEPT_ENCODING'] = ENV['HTTP_ACCEPT_ENCODING'], "gzip,deflate"
    begin
      @cgi.accept_encoding.should == "gzip,deflate"
    ensure
      ENV['HTTP_ACCEPT_ENCODING'] = old_value
    end
  end
end
