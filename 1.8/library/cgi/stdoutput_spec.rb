require File.dirname(__FILE__) + '/../../spec_helper'
require 'cgi'

describe "CGI#stdoutput" do
  before(:each) do
    ENV['REQUEST_METHOD'], @old_request_method = "GET", ENV['REQUEST_METHOD']
    @cgi = CGI.new
  end
  
  after(:each) do
    ENV['REQUEST_METHOD'] = @old_request_method
  end

  it "is private" do
    @cgi.private_methods.should include("stdoutput")
  end
  
  it "returns $stdout" do
    @cgi.send(:stdoutput).should equal($stdout)
  end
end
