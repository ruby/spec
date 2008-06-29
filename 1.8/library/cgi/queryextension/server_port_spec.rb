require File.dirname(__FILE__) + '/../../../spec_helper'
require 'cgi'

describe "CGI::QueryExtension#server_port" do
  before(:each) do
    @cgi = CGI.new
  end

  it "returns ENV['SERVER_PORT'] as Integer" do
    old_value = ENV['SERVER_PORT']
    begin
      ENV['SERVER_PORT'] = nil
      @cgi.server_port.should be_nil

      ENV['SERVER_PORT'] = "3000"
      @cgi.server_port.should eql(3000)
    ensure
      ENV['SERVER_PORT'] = old_value
    end
  end
end
