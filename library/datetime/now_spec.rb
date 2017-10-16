require File.expand_path('../../../spec_helper', __FILE__)
require 'date'

describe "DateTime.now" do
  it "creates an instance of DateTime" do
    DateTime.now.should be_an_instance_of(DateTime)
  end

  it "sets the current date" do
    dt = DateTime.now
    check = `date "+%Y-%m-%d"`.strip
    date = check.match(/(\d{4})-(\d{2})-(\d{2})/)

    dt.year.should == date[1].to_i
    dt.mon.should == date[2].to_i
    dt.day.should == date[3].to_i
  end

  it "sets the current time" do
    dt = DateTime.now
    check = `date "+%H:%M:%S"`.strip
    time = check.match(/(\d{2})\:(\d{2})\:(\d{2})/)

    dt.hour.should == time[1].to_i
    dt.min.should == time[2].to_i
    dt.sec.should == time[3].to_i
  end

  it "grabs the local timezone" do
    with_timezone("PDT", -8) do
      dt = DateTime.now
      dt.zone.should == "-08:00"
    end
  end
end
