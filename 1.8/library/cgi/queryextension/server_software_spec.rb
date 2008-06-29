require File.dirname(__FILE__) + '/../../../spec_helper'
require 'cgi'

describe "CGI::QueryExtension#server_software" do
  before(:each) do
    @cgi = CGI.new
  end
  
  it "returns ENV['SERVER_SOFTWARE']" do
    old_value, ENV['SERVER_SOFTWARE'] = ENV['SERVER_SOFTWARE'], "Server/1.0.0"
    begin
      @cgi.server_software.should == "Server/1.0.0"
    ensure
      ENV['SERVER_SOFTWARE'] = old_value
    end
  end
end
