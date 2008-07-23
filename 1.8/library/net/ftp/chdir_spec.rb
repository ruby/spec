require File.dirname(__FILE__) + '/../../../spec_helper'
require 'net/ftp'
require File.dirname(__FILE__) + "/fixtures/server"

describe "Net::FTP#chdir" do
  before(:each) do
    @server = NetFTPSpecs::DummyFTP.new
    @server.serve_once

    @ftp = Net::FTP.new
    @ftp.connect("localhost", 9921)
  end

  after(:each) do
    @ftp.quit rescue nil
    @server.stop
  end
  
  describe "when switching to the parent directory" do
    it "sends the 'CDUP' command to the server" do
      @ftp.chdir("..")
      @ftp.last_response.should == "200 Command okay. (CDUP)\n"
    end
    
    it "returns nil" do
      @ftp.chdir("..").should be_nil
    end

    # BUG: These raise a NoMethodError
    # 
    # it "raises a Net::FTPProtoError when the response code is 500" do
    #   @socket.should_receive(:readline).and_return("500 Syntax error, command unrecognized.")
    #   lambda { @ftp.chdir("..") }.should raise_error(Net::FTPProtoError)
    # end
    # 
    # it "raises a Net::FTPProtoError when the response code is 501" do
    #   @socket.should_receive(:readline).and_return("501 Syntax error in parameters or arguments.")
    #   lambda { @ftp.chdir("..") }.should raise_error(Net::FTPProtoError)
    # end
    # 
    # it "raises a Net::FTPProtoError when the response code is 502" do
    #   @socket.should_receive(:readline).and_return("502 Command not implemented.")
    #   lambda { @ftp.chdir("..") }.should raise_error(Net::FTPProtoError)
    # end
    # 
    # it "raises a Net::FTPProtoError when the response code is 421" do
    #   @socket.should_receive(:readline).and_return("421 Service not available, closing control connection.")
    #   lambda { @ftp.chdir("..") }.should raise_error(Net::FTPProtoError)
    # end
    # 
    # it "raises a Net::FTPProtoError when the response code is 530" do
    #   @socket.should_receive(:readline).and_return("530 Not logged in.")
    #   lambda { @ftp.chdir("..") }.should raise_error(Net::FTPProtoError)
    # end
    # 
    # it "raises a Net::FTPProtoError when the response code is 550" do
    #   @socket.should_receive(:readline).and_return("550 Requested action not taken.")
    #   lambda { @ftp.chdir("..") }.should raise_error(Net::FTPProtoError)
    # end
  end

  it "writes the 'CWD' command with the passed directory to the socket" do
    @ftp.chdir("test")
    @ftp.last_response.should == "200 Command okay. (CWD test)\n"
  end
  
  it "returns nil" do
    @ftp.chdir("test").should be_nil
  end

  # BUG: These raise a NoMethodError
  #
  # it "raises a Net::FTPProtoError when the response code is 500" do
  #   @socket.should_receive(:readline).and_return("500 Syntax error, command unrecognized.")
  #   lambda { @ftp.chdir("test") }.should raise_error(Net::FTPProtoError)
  # end
  # 
  # it "raises a Net::FTPProtoError when the response code is 501" do
  #   @socket.should_receive(:readline).and_return("501 Syntax error in parameters or arguments.")
  #   lambda { @ftp.chdir("test") }.should raise_error(Net::FTPProtoError)
  # end
  # 
  # it "raises a Net::FTPProtoError when the response code is 502" do
  #   @socket.should_receive(:readline).and_return("502 Command not implemented.")
  #   lambda { @ftp.chdir("test") }.should raise_error(Net::FTPProtoError)
  # end
  # 
  # it "raises a Net::FTPProtoError when the response code is 421" do
  #   @socket.should_receive(:readline).and_return("421 Service not available, closing control connection.")
  #   lambda { @ftp.chdir("test") }.should raise_error(Net::FTPProtoError)
  # end
  # 
  # it "raises a Net::FTPProtoError when the response code is 530" do
  #   @socket.should_receive(:readline).and_return("530 Not logged in.")
  #   lambda { @ftp.chdir("test") }.should raise_error(Net::FTPProtoError)
  # end
  # 
  # it "raises a Net::FTPProtoError when the response code is 550" do
  #   @socket.should_receive(:readline).and_return("550 Requested action not taken.")
  #   lambda { @ftp.chdir("test") }.should raise_error(Net::FTPProtoError)
  # end
end
