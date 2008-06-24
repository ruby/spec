require File.dirname(__FILE__) + '/../../../spec_helper'
require 'net/http'
require File.dirname(__FILE__) + '/fixtures/http_server'

describe "Net::HTTP#inspect" do
  before(:each) do
    NetHTTPSpecs.start_server
    @net = Net::HTTP.new("localhost", 3333)
  end

  after(:each) do
    NetHTTPSpecs.stop_server
  end
  
  it "returns a String representation of self" do
    net = Net::HTTP.new("localhost", 3333)
    net.inspect.should be_kind_of(String)
    net.inspect.should == "#<Net::HTTP localhost:3333 open=false>"
    
    net.start
    net.inspect.should == "#<Net::HTTP localhost:3333 open=true>"
  end
end
