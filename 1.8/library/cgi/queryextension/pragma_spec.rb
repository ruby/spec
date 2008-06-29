require File.dirname(__FILE__) + '/../../../spec_helper'
require 'cgi'

describe "CGI::QueryExtension#pragma" do
  before(:each) do
    @cgi = CGI.new
  end
  
  it "returns ENV['HTTP_PRAGMA']" do
    old_value, ENV['HTTP_PRAGMA'] = ENV['HTTP_PRAGMA'], "no-cache"
    begin
      @cgi.pragma.should == "no-cache"
    ensure
      ENV['HTTP_PRAGMA'] = old_value
    end
  end
end
