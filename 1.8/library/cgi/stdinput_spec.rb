require File.dirname(__FILE__) + '/../../spec_helper'
require 'cgi'

describe "CGI#stdinput" do
  it "is private" do
    CGI.private_instance_methods.should include("stdinput")
  end
  
  it "returns $stdin" do
    CGI.new.send(:stdinput).should equal($stdin)
  end
end
