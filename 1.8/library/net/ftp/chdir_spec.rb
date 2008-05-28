require File.dirname(__FILE__) + '/../../../spec_helper'
require 'net/ftp'

describe "Net::FTP#chdir when switching to the parent directory" do
  before(:each) do
    @socket = mock("Socket")
    @socket.stub!(:write)
    @socket.stub!(:readline).and_return("226 Success")

    @ftp = Net::FTP.new
    @ftp.instance_variable_set(:@sock, @socket)
  end
  
  it "writes the 'CDUP' command to the socket" do
    @socket.should_receive(:write).with("CDUP\r\n")
    @ftp.chdir("..")
  end

  # FIXME: Bug... does not work, as there is no #[] method defined
  # on exceptions
  #
  # it "only raises Net::FTPPermErrors when the response code is 500" do
  #   @socket.should_receive(:readline).and_return("500 EPIC FAIL!")
  #   lambda { @ftp.chdir("..") }.should raise_error(Net::FTPPermError)
  # end
  
  it "raises a Net::FTPTempError when the response code is 4xx" do
    @socket.should_receive(:readline).and_return("421 Failure", "425 Failure")
    lambda { @ftp.chdir("..") }.should raise_error(Net::FTPTempError)
    lambda { @ftp.chdir("..") }.should raise_error(Net::FTPTempError)
  end
  
  it "raises a Net::FTPReplyError when the response code is positive but not 2xx" do
    @socket.should_receive(:readline).and_return("100 Test", "300 Test")
    lambda { @ftp.chdir("..") }.should raise_error(Net::FTPReplyError)
    lambda { @ftp.chdir("..") }.should raise_error(Net::FTPReplyError)
  end
  
  it "does not raise an error when the response code is 2xx" do
    @socket.should_receive(:readline).and_return("200 Test", "212 Test")
    @ftp.chdir("..")
    @ftp.chdir("..")
  end
end

describe "Net::FTP#chdir" do
  before(:each) do
    @socket = mock("Socket")
    @socket.stub!(:write)
    @socket.stub!(:readline).and_return("226 Success")

    @ftp = Net::FTP.new
    @ftp.instance_variable_set(:@sock, @socket)
  end
  
  it "writes the 'CWD' command with the passed directory to the socket" do
    @socket.should_receive(:write).with("CWD test\r\n")
    @ftp.chdir("test")
  end

  it "raises a Net::FTPPermError when the response code is 5xx" do
    @socket.should_receive(:readline).and_return("502 Failure", "530 Failure")
    lambda { @ftp.chdir("test") }.should raise_error(Net::FTPPermError)
    lambda { @ftp.chdir("test") }.should raise_error(Net::FTPPermError)
  end
  
  it "raises a Net::FTPTempError when the response code is 4xx" do
    @socket.should_receive(:readline).and_return("421 Failure", "425 Failure")
    lambda { @ftp.chdir("test") }.should raise_error(Net::FTPTempError)
    lambda { @ftp.chdir("test") }.should raise_error(Net::FTPTempError)
  end
  
  it "raises a Net::FTPReplyError when the response code is positive but not 2xx" do
    @socket.should_receive(:readline).and_return("100 Test", "300 Test")
    lambda { @ftp.chdir("test") }.should raise_error(Net::FTPReplyError)
    lambda { @ftp.chdir("test") }.should raise_error(Net::FTPReplyError)
  end
  
  it "does not raise an error when the response code is 2xx" do
    @socket.should_receive(:readline).and_return("200 Test", "212 Test")
    @ftp.chdir("test")
    @ftp.chdir("test")
  end
end
