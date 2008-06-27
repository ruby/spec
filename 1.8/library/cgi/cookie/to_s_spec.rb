require File.dirname(__FILE__) + '/../../../spec_helper'
require 'cgi'

describe "CGI::Cookie#to_s" do
  it "returns a String representation of self" do
    cookie = CGI::Cookie.new("test-cookie")
    cookie.to_s.should == "test-cookie=; path="
    
    cookie = CGI::Cookie.new("test-cookie", "value")
    cookie.to_s.should == "test-cookie=value; path="
    
    cookie = CGI::Cookie.new("test-cookie", "one", "two", "three")
    cookie.to_s.should == "test-cookie=one&two&three; path="

    cookie = CGI::Cookie.new(
      'name'    => 'test-cookie',
      'value'   => ["one", "two", "three"],
      'path'    => 'some/path/',
      'domain'  => 'example.com',
      'expires' => Time.at(1196524602),
      'secure'  => true)
    cookie.to_s.should == "test-cookie=one&two&three; domain=example.com; path=some/path/; expires=Sat, 01 Dec 2007 15:56:42 GMT; secure"
  end
end
