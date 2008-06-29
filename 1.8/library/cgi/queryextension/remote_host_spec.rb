require File.dirname(__FILE__) + '/../../../spec_helper'
require 'cgi'

describe "CGI::QueryExtension#remote_host" do
  before(:each) do
    @cgi = CGI.new
  end
  
  it "returns ENV['REMOTE_HOST']" do
    old_value, ENV['REMOTE_HOST'] = ENV['REMOTE_HOST'], "test.host"
    begin
      @cgi.remote_host.should == "test.host"
    ensure
      ENV['REMOTE_HOST'] = old_value
    end
  end
end
