require File.dirname(__FILE__) + '/../../spec_helper'
require 'cgi'

describe "CGI#env_table" do
  before(:each) do
    ENV['REQUEST_METHOD'], @old_request_method = "GET", ENV['REQUEST_METHOD']
    @cgi = CGI.new
  end
  
  after(:each) do
    ENV['REQUEST_METHOD'] = @old_request_method
  end
  
  it "is private" do
    @cgi.private_methods.should include("env_table")
  end
  
  it "returns ENV" do
    @cgi.send(:env_table).should equal(ENV)
  end
end
