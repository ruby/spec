require File.dirname(__FILE__) + '/../../../spec_helper'
require 'cgi'

describe "CGI::QueryExtension#accept_language" do
  before(:each) do
    @cgi = CGI.new
  end
  
  it "returns ENV['HTTP_ACCEPT_LANGUAGE']" do
    old_value, ENV['HTTP_ACCEPT_LANGUAGE'] = ENV['HTTP_ACCEPT_LANGUAGE'], "en-us,en;q=0.5"
    begin
      @cgi.accept_language.should == "en-us,en;q=0.5"
    ensure
      ENV['HTTP_ACCEPT_LANGUAGE'] = old_value
    end
  end
end
