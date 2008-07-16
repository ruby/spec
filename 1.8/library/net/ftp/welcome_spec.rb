require File.dirname(__FILE__) + '/../../../spec_helper'
require 'net/ftp'

describe "Net::FTP#welcome" do
  before(:each) do
    @socket = mock("Socket")
    @socket.stub!(:write)
    
    @ftp = Net::FTP.new
    @ftp.instance_variable_set(:@sock, @socket)
  end
  
  it "returns the server's welcome message" do
    @socket.should_receive(:readline).and_return("230 User logged in, proceed.")
    
    @ftp.welcome.should be_nil
    @ftp.login
    @ftp.welcome.should == "230 User logged in, proceed.\n"
  end
end
