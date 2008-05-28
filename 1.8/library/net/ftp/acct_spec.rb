require File.dirname(__FILE__) + '/../../../spec_helper'
require 'net/ftp'

describe "Net::FTP#acct" do
  before(:each) do
    @socket = mock("Socket")
    @socket.stub!(:write)
    @socket.stub!(:readline).and_return("226 Success")

    @ftp = Net::FTP.new
    @ftp.instance_variable_set(:@sock, @socket)
  end

  it "writes the ACCT command to the socket" do
    @socket.should_receive(:write).with("ACCT my_account\r\n")
    @ftp.acct("my_account")
  end
  
  it "raises a Net::FTPPermError when the response code is 5xx" do
    @socket.should_receive(:readline).and_return("502 Failure", "530 Failure")
    lambda { @ftp.acct("my_account") }.should raise_error(Net::FTPPermError)
    lambda { @ftp.acct("my_account") }.should raise_error(Net::FTPPermError)
  end
  
  it "raises a Net::FTPTempError when the response code is 4xx" do
    @socket.should_receive(:readline).and_return("421 Failure", "425 Failure")
    lambda { @ftp.acct("my_account") }.should raise_error(Net::FTPTempError)
    lambda { @ftp.acct("my_account") }.should raise_error(Net::FTPTempError)
  end
  
  it "raises a Net::FTPReplyError when the response code is positive but not 2xx" do
    @socket.should_receive(:readline).and_return("100 Test", "300 Test")
    lambda { @ftp.acct("my_account") }.should raise_error(Net::FTPReplyError)
    lambda { @ftp.acct("my_account") }.should raise_error(Net::FTPReplyError)
  end
  
  it "does not raise an error when the response code is 2xx" do
    @socket.should_receive(:readline).and_return("200 Test", "212 Test")
    @ftp.acct("my_account")
    @ftp.acct("my_account")
  end
end
