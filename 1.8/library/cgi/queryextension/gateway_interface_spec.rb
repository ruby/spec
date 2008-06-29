require File.dirname(__FILE__) + '/../../../spec_helper'
require 'cgi'

describe "CGI::QueryExtension#gateway_interface" do
  before(:each) do
    @cgi = CGI.new
  end
  
  it "returns ENV['GATEWAY_INTERFACE']" do
    old_value, ENV['GATEWAY_INTERFACE'] = ENV['GATEWAY_INTERFACE'], "CGI/1.1"
    begin
      @cgi.gateway_interface.should == "CGI/1.1"
    ensure
      ENV['GATEWAY_INTERFACE'] = old_value
    end
  end
end
