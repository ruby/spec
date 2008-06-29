require File.dirname(__FILE__) + '/../../../spec_helper'
require 'cgi'

describe "CGI::QueryExtension#auth_type" do
  before(:each) do
    @cgi = CGI.new
  end
  
  it "returns ENV['AUTH_TYPE']" do
    old_value, ENV['AUTH_TYPE'] = ENV['AUTH_TYPE'], "Basic"
    begin
      @cgi.auth_type.should == "Basic"
    ensure
      ENV['AUTH_TYPE'] = old_value
    end
  end
end
