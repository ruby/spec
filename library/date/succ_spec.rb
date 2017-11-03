require File.expand_path('../../../spec_helper', __FILE__)
require 'date'

describe "Date#succ" do
  it "returns following day" do
    d = Date.new(2000, 1, 1)
    d.succ.should == Date.new(2000, 1, 2)
  end
end
