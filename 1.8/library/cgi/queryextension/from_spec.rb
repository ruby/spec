require File.dirname(__FILE__) + '/../../../spec_helper'
require 'cgi'

describe "CGI::QueryExtension#from" do
  before(:each) do
    @cgi = CGI.new
  end
  
  it "returns ENV['HTTP_FROM']" do
    old_value, ENV['HTTP_FROM'] = ENV['HTTP_FROM'], "googlebot(at)googlebot.com"
    begin
      @cgi.from.should == "googlebot(at)googlebot.com"
    ensure
      ENV['HTTP_FROM'] = old_value
    end
  end
end
