require File.dirname(__FILE__) + '/../../../spec_helper'
require 'cgi'

describe "CGI::QueryExtension#negotiate" do
  before(:each) do
    @cgi = CGI.new
  end
  
  it "returns ENV['HTTP_NEGOTIATE']" do
    old_value, ENV['HTTP_NEGOTIATE'] = ENV['HTTP_NEGOTIATE'], "trans"
    begin
      @cgi.negotiate.should == "trans"
    ensure
      ENV['HTTP_NEGOTIATE'] = old_value
    end
  end
end
