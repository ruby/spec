require File.dirname(__FILE__) + '/../../../spec_helper'
require 'cgi'
require 'stringio'

describe "CGI::QueryExtension#read_from_cmdline when the ARGV Array contains values" do
  before(:each) do
    ENV['REQUEST_METHOD'], @old_request_method = "GET", ENV['REQUEST_METHOD']
    @old_argv = ARGV
    @cgi = CGI.new
  end
  
  after(:each) do
    ENV['REQUEST_METHOD'] = @old_request_method
    ARGV = @old_argv
  end

  it "returns the ARGV array converted to a HTTP Query String" do
    ARGV = ["one=value", "two=other_value", "three"]
    @cgi.send(:read_from_cmdline).should == "one=value&two=other_value&three"
  end
  
  it "returns the ARGV array concatenated with '+' when no values are given" do
    ARGV = ["one", "two", "three"]
    @cgi.send(:read_from_cmdline).should == "one+two+three"
  end
end

describe "CGI::QueryExtension#read_from_cmdline when the ARGV Array contains no values" do
  before(:each) do
    ENV['REQUEST_METHOD'], @old_request_method = "GET", ENV['REQUEST_METHOD']
    
    @old_argv = ARGV.dup
    ARGV.replace([])
    
    @old_stdin = $stdin
    @cgi = CGI.new
  end
  
  after(:each) do
    ENV['REQUEST_METHOD'] = @old_request_method
    ARGV.replace(@old_argv)
    $stdin = @old_stdin
  end

  it "returns the lines read from $stdin converted to a HTTP Query String" do
    $stdin = StringIO.new("one=value\ntwo=other_value\nthree")
    @cgi.send(:read_from_cmdline).should == "one=value&two=other_value&three"
  end
  
  it "returns the lines read from $stdin concatenated with '+' when no values are given" do
    $stdin = StringIO.new("one\ntwo\nthree")
    @cgi.send(:read_from_cmdline).should == "one+two+three"
  end
end
