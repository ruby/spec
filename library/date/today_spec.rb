require File.expand_path('../../../spec_helper', __FILE__)
require 'date'

describe "Date.today" do
  it "returns a Date object" do
    Date.today.should be_kind_of Date
  end

  it "sets Date object to the current date" do
    today = Date.today
    
    now = Time.now
    today.year.should == now.year
    today.mon.should == now.mon
    today.day.should == now.day
  end
end
