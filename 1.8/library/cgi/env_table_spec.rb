require File.dirname(__FILE__) + '/../../spec_helper'
require 'cgi'

describe "CGI#env_table" do
  it "is private" do
    CGI.private_instance_methods.should include("env_table")
  end
  
  it "returns ENV" do
    cgi = CGI.new
    cgi.send(:env_table).should equal(ENV)
  end
end
