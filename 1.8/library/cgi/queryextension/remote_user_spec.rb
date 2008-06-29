require File.dirname(__FILE__) + '/../../../spec_helper'
require 'cgi'

describe "CGI::QueryExtension#remote_user" do
  before(:each) do
    @cgi = CGI.new
  end
  
  it "returns ENV['REMOTE_USER']" do
    old_value, ENV['REMOTE_USER'] = ENV['REMOTE_USER'], "username"
    begin
      @cgi.remote_user.should == "username"
    ensure
      ENV['REMOTE_USER'] = old_value
    end
  end
end
