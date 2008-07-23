require File.dirname(__FILE__) + '/../../../spec_helper'
require 'net/ftp'
require File.dirname(__FILE__) + "/fixtures/server"
require File.dirname(__FILE__) + "/shared/gettextfile"

describe "Net::FTP#get when in binary mode" do
  it "behaves like #getbinaryfile"
end

describe "Net::FTP#get when in text mode" do
  before(:each) do
    @binary_mode = false
  end
  
  it_behaves_like :net_ftp_gettextfile, :get
end
