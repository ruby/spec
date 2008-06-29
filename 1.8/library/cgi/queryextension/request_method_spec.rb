require File.dirname(__FILE__) + '/../../../spec_helper'
require 'cgi'

describe "CGI::QueryExtension#request_method" do
  before(:each) do
    @cgi = CGI.new
  end
  
  it "returns ENV['REQUEST_METHOD']" do
    old_value, ENV['REQUEST_METHOD'] = ENV['REQUEST_METHOD'], "GET"
    begin
      @cgi.request_method.should == "GET"
    ensure
      ENV['REQUEST_METHOD'] = old_value
    end
  end
end
