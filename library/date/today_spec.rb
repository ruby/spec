require File.expand_path('../../../spec_helper', __FILE__)
require 'date'

describe "Date.today" do
  it "returns a Date object" do
    Date.today.should be_kind_of Date
  end

  it "sets Date object to the current date" do
    check = `date "+%Y-%m-%d"`.strip
    date = check.match(/(\d{4})-(\d{2})-(\d{2})/)
    today = Date.today
    today.year.should == date[1].to_i
    today.mon.should == date[2].to_i
    today.day.should == date[3].to_i
  end
end
