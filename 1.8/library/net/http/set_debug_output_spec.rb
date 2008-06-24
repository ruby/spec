require File.dirname(__FILE__) + '/../../../spec_helper'
require 'net/http'
require "stringio"
require File.dirname(__FILE__) + '/fixtures/http_server'

describe "Net::HTTP#set_debug_output when passed io" do
  before(:each) do
    NetHTTPSpecs.start_server
    @http = Net::HTTP.new("localhost", 3333)
  end

  after(:each) do
    NetHTTPSpecs.stop_server
  end
  
  it "sets the passed io as output stream for debugging" do
    io = StringIO.new
    @http.set_debug_output(io)
    @http.start
    io.string.should == "opening connection to localhost...\nopened\n"
    @http.get("/")

    io.string.should include(<<-EOS)
opening connection to localhost...
opened
<- "GET / HTTP/1.1\\r\\nAccept: */*\\r\\nHost: localhost:3333\\r\\n\\r\\n"
-> "HTTP/1.1 200 OK \\r\\n"
-> "Connection: Keep-Alive\\r\\n"
-> "Content-Type: text/plain\\r\\n"
EOS

    io.string.should include(<<-EOS)
-> "Server: WEBrick/1.3.1 (Ruby/1.8.7/2008-06-20)\\r\\n"
-> "Content-Length: 23\\r\\n"
-> "\\r\\n"
reading 23 bytes...
-> ""
-> "This is the index page."
read 23 bytes
Conn keep-alive
EOS
  end
  
  it "outputs a warning when the connection has already been started" do
    @http.start
    lambda { @http.set_debug_output(StringIO.new) }.should complain("Net::HTTP#set_debug_output called after HTTP started\n")
  end
end