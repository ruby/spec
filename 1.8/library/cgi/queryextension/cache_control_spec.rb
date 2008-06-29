require File.dirname(__FILE__) + '/../../../spec_helper'
require 'cgi'

describe "CGI::QueryExtension#cache_control" do
  before(:each) do
    @cgi = CGI.new
  end
  
  it "returns ENV['HTTP_CACHE_CONTROL']" do
    old_value, ENV['HTTP_CACHE_CONTROL'] = ENV['HTTP_CACHE_CONTROL'], "no-cache"
    begin
      @cgi.cache_control.should == "no-cache"
    ensure
      ENV['HTTP_CACHE_CONTROL'] = old_value
    end
  end
end
