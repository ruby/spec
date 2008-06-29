require File.dirname(__FILE__) + '/../../../spec_helper'
require 'cgi'

describe "CGI::QueryExtension#path_info" do
  before(:each) do
    @cgi = CGI.new
  end
  
  it "returns ENV['PATH_INFO']" do
    old_value, ENV['PATH_INFO'] = ENV['PATH_INFO'], "/test/path"
    begin
      @cgi.path_info.should == "/test/path"
    ensure
      ENV['PATH_INFO'] = old_value
    end
  end
end
