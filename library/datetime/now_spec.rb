require File.expand_path('../../../spec_helper', __FILE__)
require 'date'

describe "DateTime.now" do
  it "creates an instance of DateTime" do
    DateTime.now.should be_an_instance_of(DateTime)
  end

  it "sets the current date" do
    dt = DateTime.now
    d = Date.today

    dt.year.should == d.year
    dt.mon.should == d.mon
    dt.day.should == d.day
  end

  it "sets the current time" do
    dt = DateTime.now
    t = Time.now

    dt.hour.should == t.hour
    dt.min.should == t.min
    dt.sec.should == t.sec
  end

  it "grabs the local timezone" do
    dt = DateTime.now
    t = Time.local(dt.year, dt.mon, dt.mday, dt.hour, dt.min, dt.sec)
    dt.offset.to_i.should == t.utc_offset
  end
end
