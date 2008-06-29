require File.dirname(__FILE__) + '/../../../spec_helper'
require 'cgi'

describe "CGI::QueryExtension#content_length" do
  before(:each) do
    @cgi = CGI.new
  end
  
  it "returns ENV['CONTENT_LENGTH'] as Integer" do
    old_value = ENV['CONTENT_LENGTH']
    begin
      ENV['CONTENT_LENGTH'] = nil
      @cgi.content_length.should be_nil

      ENV['CONTENT_LENGTH'] = "100"
      @cgi.content_length.should eql(100)
    ensure
      ENV['CONTENT_LENGTH'] = old_value
    end
  end
end
