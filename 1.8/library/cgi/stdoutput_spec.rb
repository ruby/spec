require File.dirname(__FILE__) + '/../../spec_helper'
require 'cgi'

describe "CGI#stdoutput" do
  it "is private" do
    CGI.private_instance_methods.should include("stdoutput")
  end
  
  it "returns $stdout" do
    CGI.new.send(:stdoutput).should equal($stdout)
  end
end
