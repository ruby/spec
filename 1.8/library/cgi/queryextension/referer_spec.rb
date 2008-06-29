require File.dirname(__FILE__) + '/../../../spec_helper'
require 'cgi'

describe "CGI::QueryExtension#referer" do
  before(:each) do
    @cgi = CGI.new
  end
  
  it "returns ENV['HTTP_REFERER']" do
    old_value, ENV['HTTP_REFERER'] = ENV['HTTP_REFERER'], "example.com"
    begin
      @cgi.referer.should == "example.com"
    ensure
      ENV['HTTP_REFERER'] = old_value
    end
  end
end
