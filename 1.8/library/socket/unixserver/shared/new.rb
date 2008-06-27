require File.dirname(__FILE__) + '/../../../../spec_helper'
require File.dirname(__FILE__) + '/../../fixtures/classes'
require 'tempfile'

shared :new do |cmd|
  describe "UNIXServer.#{cmd}" do
    not_supported_on :windows do
      
      it "creates a new UNIXServer" do
        path = tmp("unixserver_spec")
        File.unlink(path) if File.exists?(path)
        unix = UNIXServer.new(path)
        unix.path.should == path
        unix.addr.should == ["AF_UNIX", path]
      end

      it "is not connected" do
        path = tmp("unixserver_spec")
        File.unlink(path) if File.exists?(path)
        unix = UNIXServer.new(path)
        lambda { unix.peeraddr }.should raise_error
      end
    end
  end
end
