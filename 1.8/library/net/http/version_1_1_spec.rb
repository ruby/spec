require File.dirname(__FILE__) + '/../../../spec_helper'
require 'net/http'

describe "Net::HTTP.version_1_1" do
  it "turns on net/http 1.1 features" do
    Net::HTTP.version_1_1
    
    Net::HTTP.version_1_1?.should be_true
    Net::HTTP.version_1_2?.should be_false
  end
  
  it "returns false" do
    Net::HTTP.version_1_1.should be_false
  end
end

describe "Net::HTTP.version_1_1?" do
  it "returns the state of net/http 1.1 features" do
    Net::HTTP.version_1_1?.should be_false
    Net::HTTP.version_1_1
    Net::HTTP.version_1_1?.should be_true
  end
end
