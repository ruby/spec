require File.dirname(__FILE__) + '/../../../spec_helper'
require 'net/ftp'
require File.dirname(__FILE__) + "/fixtures/server.rb"

describe "Net::FTP#abort" do
  def with_connection
    @ftp.connect("localhost", 9921)
    yield
  end
  
  before(:each) do
    @server = NetFTPSpecs::DummyFTP.new
    @server.serve_once
    @server.should_receive("ABOR\r")

    @ftp = Net::FTP.new
  end

  after(:each) do
    @ftp.quit
    @server.stop
  end

  it "sends the ABOR command over the socket" do
    @server.should_respond("226 Closing data connection.")
    lambda { with_connection { @ftp.abort } }.should_not raise_error
  end
  
  it "returns the full response" do
    @server.should_respond("226 Closing data connection.")
    with_connection { @ftp.abort }.should == "226 Closing data connection.\n"
  end
  
  it "does not raise any error when the response code is 225" do
    @server.should_respond("225 Data connection open; no transfer in progress.")
    lambda { with_connection { @ftp.abort } }.should_not raise_error
  end
  
  it "does not raise any error when the response code is 226" do
    @server.should_respond("226 Closing data connection.")
    lambda { with_connection { @ftp.abort } }.should_not raise_error
  end
  
  it "raises a Net::FTPProtoError when the response code is 500" do
    @server.should_respond("500 Syntax error, command unrecognized.")
    lambda { with_connection { @ftp.abort } }.should raise_error(Net::FTPProtoError)
  end
  
  it "raises a Net::FTPProtoError when the response code is 501" do
    @server.should_respond("501 Syntax error in parameters or arguments.")
    lambda { with_connection { @ftp.abort } }.should raise_error(Net::FTPProtoError)
  end
  
  it "raises a Net::FTPProtoError when the response code is 502" do
    @server.should_respond("502 Command not implemented.")
    lambda { with_connection { @ftp.abort } }.should raise_error(Net::FTPProtoError)
  end
  
  it "raises a Net::FTPProtoError when the response code is 421" do
    @server.should_respond("421 Service not available, closing control connection.")
    lambda { with_connection { @ftp.abort } }.should raise_error(Net::FTPProtoError)
  end
end