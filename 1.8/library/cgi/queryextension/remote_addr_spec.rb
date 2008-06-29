require File.dirname(__FILE__) + '/../../../spec_helper'
require 'cgi'

describe "CGI::QueryExtension#remote_addr" do
  before(:each) do
    @cgi = CGI.new
  end
  
  it "returns ENV['REMOTE_ADDR']" do
    old_value, ENV['REMOTE_ADDR'] = ENV['REMOTE_ADDR'], "127.0.0.1"
    begin
      @cgi.remote_addr.should == "127.0.0.1"
    ensure
      ENV['REMOTE_ADDR'] = old_value
    end
  end
end
