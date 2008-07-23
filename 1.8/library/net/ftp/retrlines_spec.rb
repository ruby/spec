require File.dirname(__FILE__) + '/../../../spec_helper'
require 'net/ftp'

describe "Net::FTP#retrlines" do
  before(:each) do
    @socket = mock("Socket")
    @socket.stub!(:addr).and_return(["AF_INET", nil, nil, "127.0.0.1"])
    @socket.stub!(:peeraddr).and_return(["AF_INET", nil, nil, "127.0.0.1"])
    @socket.stub!(:write)
    @socket.stub!(:readline).and_return("200 Command okay.", "200 Command okay.", "123 test", "200 Command okay.")
    
    @connection = mock("Connection")
    @connection.stub!(:gets).and_return("Line 1", "Line 2", "Line 3", nil)
    @connection.stub!(:close)

    @server_socket = mock("Server Socket")
    @server_socket.stub!(:accept).and_return(@connection)
    @server_socket.stub!(:close)
    @server_socket.stub!(:addr).and_return(["AF_INET", 1234, nil, "127.0.0.1"])
    TCPServer.stub!(:open).and_return(@server_socket)
    
    @ftp = Net::FTP.new
    @ftp.instance_variable_set(:@sock, @socket)
  end

  it "puts the connection into ASCII mode" do
    @socket.should_receive(:write).with("TYPE A\r\n")
    @ftp.retrlines("COMMAND") {}
  end

  it "sends the passed command over the socket" do
    @socket.should_receive(:write).with("COMMAND\r\n")
    @ftp.retrlines("COMMAND") {}
  end

  it "yields each line to the passed block" do
    res = []
    @ftp.retrlines("COMMAND") { |x| res << x }
    res.should == ["Line 1", "Line 2", "Line 3"]
  end
end
