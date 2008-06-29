require File.dirname(__FILE__) + '/../../../spec_helper'
require 'cgi'

describe "CGI::QueryExtension#script_name" do
  before(:each) do
    @cgi = CGI.new
  end
  
  it "returns ENV['SCRIPT_NAME']" do
    old_value, ENV['SCRIPT_NAME'] = ENV['SCRIPT_NAME'], "/path/to/script.rb"
    begin
      @cgi.script_name.should == "/path/to/script.rb"
    ensure
      ENV['SCRIPT_NAME'] = old_value
    end
  end
end
