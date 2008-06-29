require File.dirname(__FILE__) + '/../../../spec_helper'
require 'cgi'

describe "CGI::QueryExtension#raw_cookie2" do
  before(:each) do
    @cgi = CGI.new
  end
  
  it "returns ENV['HTTP_COOKIE2']" do
    old_value, ENV['HTTP_COOKIE2'] = ENV['HTTP_COOKIE2'], "some_cookie=data"
    begin
      @cgi.raw_cookie2.should == "some_cookie=data"
    ensure
      ENV['HTTP_COOKIE2'] = old_value
    end
  end
end
