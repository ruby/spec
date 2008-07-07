require File.dirname(__FILE__) + '/../../../spec_helper'
require 'cgi'
require "stringio"

describe "CGI::QueryExtension#multipart?" do
  before(:each) do
    @old_env = ENV.dup
    @old_stdin = $stdin
    
    ENV['REQUEST_METHOD'] = "POST"
    ENV["CONTENT_TYPE"] = "multipart/form-data; boundary=---------------------------1137522503144128232716531729"
    ENV["CONTENT_LENGTH"] = "222"
    
    $stdin = StringIO.new <<-EOS
-----------------------------1137522503144128232716531729\r
Content-Disposition: form-data; name="file"; filename=""\r
Content-Type: application/octet-stream\r
\r
\r
-----------------------------1137522503144128232716531729--\r
EOS

    @cgi = CGI.new
  end
  
  after(:each) do
    ENV = @old_env
    $stdin = @old_stdin
  end
  
  it "returns true if the current Request is a multipart request" do
    @cgi.multipart?.should be_true
  end
end
