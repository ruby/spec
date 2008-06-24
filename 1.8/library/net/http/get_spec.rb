require File.dirname(__FILE__) + '/../../../spec_helper'
require 'net/http'
require File.dirname(__FILE__) + '/fixtures/http_server'

describe "Net::HTTP.get when passed URI" do
  before(:each) do
    NetHTTPSpecs.start_server
  end
  
  after(:each) do
    NetHTTPSpecs.stop_server
  end
  
  it "returns the body of the specified uri" do
    Net::HTTP.get(URI.parse('http://localhost:3333/')).should == "This is the index page."
  end
end

describe "Net::HTTP.get when passed host, path, port" do
  before(:each) do
    NetHTTPSpecs.start_server
  end
  
  after(:each) do
    NetHTTPSpecs.stop_server
  end
  
  it "returns the body of the specified host-path-combination" do
    Net::HTTP.get('localhost', "/", 3333).should == "This is the index page."
  end
end

describe "Net::HTTP#get" do
  it "needs to be reviewed for spec completeness" do
  end
end
