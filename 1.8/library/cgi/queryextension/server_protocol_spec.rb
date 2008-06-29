require File.dirname(__FILE__) + '/../../../spec_helper'
require 'cgi'

describe "CGI::QueryExtension#server_protocol" do
  before(:each) do
    @cgi = CGI.new
  end
  
  it "returns ENV['SERVER_PROTOCOL']" do
    old_value, ENV['SERVER_PROTOCOL'] = ENV['SERVER_PROTOCOL'], "HTTP/1.1"
    begin
      @cgi.server_protocol.should == "HTTP/1.1"
    ensure
      ENV['SERVER_PROTOCOL'] = old_value
    end
  end
end
