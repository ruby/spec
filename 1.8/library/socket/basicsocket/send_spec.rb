require File.dirname(__FILE__) + '/../../../spec_helper'
require File.dirname(__FILE__) + '/../fixtures/classes'

describe "BasicSocket#send" do
  it "sends a message to another socket and returns the number of bytes sent" do
    # TCPSocket inherits from BasicSocket
    server = TCPServer.new('127.0.0.1', SocketSpecs.port)
    data = nil
    t = Thread.new do
      client = server.accept
      data = client.recv(5)
      client.close
    end
    Thread.pass until t.status == "sleep"
    socket = TCPSocket.new('127.0.0.1', SocketSpecs.port)
    socket.send('hello', 0).should == 5
    t.join
    data.should == 'hello'
    socket.close
    server.close
  end

  it "accepts flags to specify unusual sending behaviour" do
    server = TCPServer.new('127.0.0.1', SocketSpecs.port)
    data = nil
    t = Thread.new do
      client = server.accept
      data = client.recv(6)
      client.close
    end
    Thread.pass until t.status == "sleep"
    socket = TCPSocket.new('127.0.0.1', SocketSpecs.port)
    socket.send('helloU', Socket::MSG_OOB).should == 6
    t.join
    data.should == 'hello'
    socket.close
    server.close
  end
end
