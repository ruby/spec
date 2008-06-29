require File.dirname(__FILE__) + '/../../../spec_helper'
require 'cgi'

describe "CGI::QueryExtension#path_translated" do
  before(:each) do
    @cgi = CGI.new
  end
  
  it "returns ENV['PATH_TRANSLATED']" do
    old_value, ENV['PATH_TRANSLATED'] = ENV['PATH_TRANSLATED'], "/full/path/to/dir"
    begin
      @cgi.path_translated.should == "/full/path/to/dir"
    ensure
      ENV['PATH_TRANSLATED'] = old_value
    end
  end
end
