require File.dirname(__FILE__) + '/../../../spec_helper'
require File.dirname(__FILE__) + '/../fixtures/classes'

require 'socket'

describe "Socket#getnameinfo" do
  before :each do
  end

  after :each do
  end

  it "gets the name information and don't resolve it" do
    BasicSocket.do_not_reverse_lookup = true
    expected = [ "#{SocketSpecs.port}", '127.0.0.1']
    sockaddr = Socket.sockaddr_in SocketSpecs.port, '127.0.0.1'
    Socket.getnameinfo(sockaddr, Socket::NI_NUMERICHOST | Socket::NI_NUMERICSERV).each do |a|
        expected.should include(a)
    end
  end

  it "gets the name information and resolve the host" do
    BasicSocket.do_not_reverse_lookup = true
    expected = [ "#{SocketSpecs.port}", 'localhost']
    sockaddr = Socket.sockaddr_in SocketSpecs.port, '127.0.0.1'
    Socket.getnameinfo(sockaddr, Socket::NI_NUMERICSERV).each do |a|
        expected.should include(a)
    end
  end

  it "gets the name information and resolve the port" do
    BasicSocket.do_not_reverse_lookup = true
    expected = [ "http", 'localhost']
    sockaddr = Socket.sockaddr_in 80, '127.0.0.1'
    Socket.getnameinfo(sockaddr).each do |a|
        expected.should include(a)
    end
  end

end

