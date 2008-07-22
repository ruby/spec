require File.dirname(__FILE__) + '/../../../spec_helper'
require 'net/ftp'
require File.dirname(__FILE__) + "/fixtures/server.rb"

describe "Net::FTP#acct" do
  include NetFTPSpecs

  before(:each) do
    @server = NetFTPSpecs::DummyFTP.new
    @server.serve_once
    @server.should_receive("ACCT my_account\r\n")

    @ftp = Net::FTP.new
  end

  after(:each) do
    @ftp.quit
    @server.stop
  end

  it "writes the ACCT command to the server" do
    @server.should_respond("230 User logged in, proceed.")
    with_connection { @ftp.acct("my_account") }
  end
  
  it "does not raise any error when the response code is 230" do
    @server.should_respond("230 User logged in, proceed.")
    with_connection { @ftp.acct("my_account") }
  end
  
  it "raises a Net::FTPPermError when the response code is 530" do
    @server.should_respond("530 Not logged in.")
    lambda { with_connection { @ftp.acct("my_account") } }.should raise_error(Net::FTPPermError)
  end
  
  it "raises a Net::FTPPermError when the response code is 500" do
    @server.should_respond("500 Syntax error, command unrecognized.")
    lambda { with_connection { @ftp.acct("my_account") } }.should raise_error(Net::FTPPermError)
  end
  
  it "raises a Net::FTPPermError when the response code is 501" do
    @server.should_respond("501 Syntax error in parameters or arguments.")
    lambda { with_connection { @ftp.acct("my_account") } }.should raise_error(Net::FTPPermError)
  end
  
  it "raises a Net::FTPPermError when the response code is 503" do
    @server.should_respond("503 Bad sequence of commands.")
    lambda { with_connection { @ftp.acct("my_account") } }.should raise_error(Net::FTPPermError)
  end
  
  it "raises a Net::FTPTempError when the response code is 421" do
    @server.should_respond("421 Service not available, closing control connection.")
    lambda { with_connection { @ftp.acct("my_account") } }.should raise_error(Net::FTPTempError)
  end
end
