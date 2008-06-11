require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'

describe "StringIO#fileno" do
  it "is nil" do
    StringIO.new("nuffin").fileno.should be_nil
  end
end
