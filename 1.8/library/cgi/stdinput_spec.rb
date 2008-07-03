require File.dirname(__FILE__) + '/../../spec_helper'
require 'cgi'

describe "CGI#stdinput" do
  before(:each) do
    ENV['REQUEST_METHOD'], @old_request_method = "GET", ENV['REQUEST_METHOD']
    @cgi = CGI.new
  end
  
  after(:each) do
    ENV['REQUEST_METHOD'] = @old_request_method
  end

  it "is private" do
    @cgi.private_methods.should include("stdinput")
  end
  
  it "returns $stdin" do
    @cgi.send(:stdinput).should equal($stdin)
  end
end
