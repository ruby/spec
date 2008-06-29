require File.dirname(__FILE__) + '/../../../spec_helper'
require 'cgi'

describe "CGI::QueryExtension#content_type" do
  before(:each) do
    @cgi = CGI.new
  end
  
  it "returns ENV['CONTENT_TYPE']" do
    old_value, ENV['CONTENT_TYPE'] = ENV['CONTENT_TYPE'], "text/html"
    begin
      @cgi.content_type.should == "text/html"
    ensure
      ENV['CONTENT_TYPE'] = old_value
    end
  end
end
