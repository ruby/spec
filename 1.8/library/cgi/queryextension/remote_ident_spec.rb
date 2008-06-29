require File.dirname(__FILE__) + '/../../../spec_helper'
require 'cgi'

describe "CGI::QueryExtension#remote_ident" do
  before(:each) do
    @cgi = CGI.new
  end
  
  it "returns ENV['REMOTE_IDENT']" do
    old_value, ENV['REMOTE_IDENT'] = ENV['REMOTE_IDENT'], "no-idea-what-this-is-for"
    begin
      @cgi.remote_ident.should == "no-idea-what-this-is-for"
    ensure
      ENV['REMOTE_IDENT'] = old_value
    end
  end
end
