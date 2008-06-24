require File.dirname(__FILE__) + '/../../../spec_helper'
require 'net/http'
require File.dirname(__FILE__) + '/fixtures/http_server'

describe "Net::HTTP#do_start" do
  before(:each) do
    NetHTTPSpecs.start_server
    @http = Net::HTTP.new("localhost", 3333)
  end
  
  after(:each) do
    NetHTTPSpecs.stop_server
  end
  
  it "is private" do
    Net::HTTP.private_instance_methods.should include("do_start")
  end

  it "opens the tcp connection to the current host" do
    @http.should_receive(:connect)
    @http.send(:do_start)
    @http.started?.should be_true
  end
end
