require File.dirname(__FILE__) + '/../../../spec_helper'
require 'cgi'

describe "CGI::QueryExtension#host" do
  before(:each) do
    @cgi = CGI.new
  end
  
  it "returns ENV['HTTP_HOST']" do
    old_value, ENV['HTTP_HOST'] = ENV['HTTP_HOST'], "localhost"
    begin
      @cgi.host.should == "localhost"
    ensure
      ENV['HTTP_HOST'] = old_value
    end
  end
end
