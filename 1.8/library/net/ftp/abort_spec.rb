require File.dirname(__FILE__) + '/../../../spec_helper'
require 'net/ftp'

describe "Net::FTP#abort" do
  before(:each) do
    @socket = mock("Socket")
    @socket.stub!(:send)
    @socket.stub!(:readline).and_return("226 Ignored")
    
    @ftp = Net::FTP.new
    @ftp.instance_variable_set(:@sock, @socket)
  end
  
  it "sends 'ABOR\\r\\n' over the socket" do
    @socket.should_receive(:send).with("ABOR\r\n", Socket::MSG_OOB)
    @ftp.abort
  end
  
  it "returns the full response" do
    @socket.should_receive(:readline).and_return("226 Ignored")
    @ftp.abort.should == "226 Ignored\n"
  end
  
  it "does not raise a Net::FTPProtoError when the response code is 426, 226 or 225" do
    @socket.should_receive(:readline).and_return("426 Ignored", "226 Ignored", "225 Ignored")
    lambda { @ftp.abort }.should_not raise_error(Net::FTPProtoError)
    lambda { @ftp.abort }.should_not raise_error(Net::FTPProtoError)
    lambda { @ftp.abort }.should_not raise_error(Net::FTPProtoError)
  end

  it "raises a Net::FTPProtoError when the response code is not 426, 226 or 225" do
    @socket.should_receive(:readline).and_return("227 Ignored", "228 Ignored", "224 Ignored")
    lambda { @ftp.abort }.should raise_error(Net::FTPProtoError)
    lambda { @ftp.abort }.should raise_error(Net::FTPProtoError)
    lambda { @ftp.abort }.should raise_error(Net::FTPProtoError)
  end
end