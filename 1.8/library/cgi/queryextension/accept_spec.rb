require File.dirname(__FILE__) + '/../../../spec_helper'
require 'cgi'

describe "CGI::QueryExtension#accept" do
  before(:each) do
    @cgi = CGI.new
  end
  
  it "returns ENV['HTTP_ACCEPT']" do
    old_value, ENV['HTTP_ACCEPT'] = ENV['HTTP_ACCEPT'], "text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5"
    begin
      @cgi.accept.should == "text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5"
    ensure
      ENV['HTTP_ACCEPT'] = old_value
    end
  end
end
