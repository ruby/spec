require File.dirname(__FILE__) + '/../../../spec_helper'
require 'cgi'

describe "CGI::QueryExtension#raw_cookie" do
  before(:each) do
    @cgi = CGI.new
  end
  
  it "returns ENV['HTTP_COOKIE']" do
    old_value, ENV['HTTP_COOKIE'] = ENV['HTTP_COOKIE'], "some_cookie=data"
    begin
      @cgi.raw_cookie.should == "some_cookie=data"
    ensure
      ENV['HTTP_COOKIE'] = old_value
    end
  end
end
