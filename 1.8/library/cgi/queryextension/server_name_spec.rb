require File.dirname(__FILE__) + '/../../../spec_helper'
require 'cgi'

describe "CGI::QueryExtension#server_name" do
  before(:each) do
    @cgi = CGI.new
  end
  
  it "returns ENV['SERVER_NAME']" do
    old_value, ENV['SERVER_NAME'] = ENV['SERVER_NAME'], "localhost"
    begin
      @cgi.server_name.should == "localhost"
    ensure
      ENV['SERVER_NAME'] = old_value
    end
  end
end
