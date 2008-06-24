require File.dirname(__FILE__) + '/../../../spec_helper'
require File.dirname(__FILE__) + '/../fixtures/classes'

include Socket::Constants

describe "Socket#bind" do

  before :each do
    @sock = Socket.new(AF_INET, SOCK_STREAM, 0);    
  end

  after :each do
    @sock.close unless @sock.closed?
  end                           

  # TODO: Needs to actually check something.
  it "binds to a port" do
    sockaddr = Socket.pack_sockaddr_in(SocketSpecs.port, "127.0.0.1");
    @sock.bind(sockaddr);
  end
  
  it "raises an error if we try to bind to an already bound port" do
    sockaddr = Socket.pack_sockaddr_in(SocketSpecs.port, "127.0.0.1");
    @sock.bind(sockaddr);

    sock2 = Socket.new(AF_INET, SOCK_STREAM, 0);
    lambda { sock2.bind(sockaddr) }.should raise_error;
    sock2.close if (sock2 && !sock2.closed?)
  end
end
