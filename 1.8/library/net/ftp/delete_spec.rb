require File.dirname(__FILE__) + '/../../../spec_helper'
require 'net/ftp'
require File.dirname(__FILE__) + "/fixtures/server.rb"

describe "Net::FTP#delete" do
  def with_connection
    @ftp.connect("localhost", 9921)
    yield
  end
  
  before(:each) do
    @server = NetFTPSpecs::DummyFTP.new
    @server.serve_once

    @ftp = Net::FTP.new
  end

  after(:each) do
    @ftp.quit
    @server.stop
  end
  
  it "sends the DELE command with the passed filename to the server" do
    @server.should_receive("DELE test.file\r\n").and_respond("250 Requested file action okay, completed.")
    lambda { with_connection { @ftp.delete("test.file") } }.should_not raise_error
  end

  it "raises a Net::FTPTempError when the response code is 450" do
    @server.should_receive("DELE test.file\r\n").and_respond("450 Requested file action not taken.")
    lambda { with_connection { @ftp.delete("test.file") } }.should raise_error(Net::FTPTempError)
  end

  it "raises a Net::FTPPermError when the response code is 550" do
    @server.should_receive("DELE test.file\r\n").and_respond("550 Requested action not taken.")
    lambda { with_connection { @ftp.delete("test.file") } }.should raise_error(Net::FTPPermError)
  end

  it "raises a Net::FTPPermError when the response code is 500" do
    @server.should_receive("DELE test.file\r\n").and_respond("500 Syntax error, command unrecognized.")
    lambda { with_connection { @ftp.delete("test.file") } }.should raise_error(Net::FTPPermError)
  end
  
  it "raises a Net::FTPPermError when the response code is 501" do
    @server.should_receive("DELE test.file\r\n").and_respond("501 Syntax error in parameters or arguments.")
    lambda { with_connection { @ftp.delete("test.file") } }.should raise_error(Net::FTPPermError)
  end

  it "raises a Net::FTPPermError when the response code is 502" do
    @server.should_receive("DELE test.file\r\n").and_respond("502 Command not implemented.")
    lambda { with_connection { @ftp.delete("test.file") } }.should raise_error(Net::FTPPermError)
  end

  it "raises a Net::FTPTempError when the response code is 421" do
    @server.should_receive("DELE test.file\r\n").and_respond("421 Service not available, closing control connection.")
    lambda { with_connection { @ftp.delete("test.file") } }.should raise_error(Net::FTPTempError)
  end

  it "raises a Net::FTPPermError when the response code is 530" do
    @server.should_receive("DELE test.file\r\n").and_respond("530 Not logged in.")
    lambda { with_connection { @ftp.delete("test.file") } }.should raise_error(Net::FTPPermError)
  end
end