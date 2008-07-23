require File.dirname(__FILE__) + '/../../../spec_helper'
require 'net/ftp'

describe "Net::FTP#get when in binary mode" do
  it "behaves like #getbinaryfile"
end

describe "Net::FTP when in text mode" do
  it "behaves like #gettextfile"
end
