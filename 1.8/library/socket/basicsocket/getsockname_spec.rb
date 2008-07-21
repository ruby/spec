require File.dirname(__FILE__) + '/../../../spec_helper'
require File.dirname(__FILE__) + '/../fixtures/classes'

describe "Socket::BasicSocket#getsockname" do
  after :each do
    @socket.closed?.should be_false
    @socket.close
  end

  it "returns the sockaddr associacted with the socket" do
    @socket = TCPServer.new("127.0.0.1", SocketSpecs.port)
    sockaddr = Socket.unpack_sockaddr_in(@socket.getsockname)
    sockaddr.should == [SocketSpecs.port, "127.0.0.1"]
 end

  it "works on sockets listening in 0.0.0.0" do
    @socket = TCPServer.new(SocketSpecs.port)
    sockaddr = Socket.unpack_sockaddr_in(@socket.getsockname)
    sockaddr.should == [SocketSpecs.port, "0.0.0.0"]
  end

  it "returns empty sockaddr for unbinded sockets" do
    @socket = Socket.new(Socket::AF_INET, Socket::SOCK_STREAM, 0)
    sockaddr = Socket.unpack_sockaddr_in(@socket.getsockname)
    sockaddr.should == [0, "0.0.0.0"]
  end
end
