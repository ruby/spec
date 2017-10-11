require File.expand_path('../../../spec_helper', __FILE__)
require 'date'

ruby_version_is "2.4" do
  describe "DateTime#to_time" do
    it "yields a new Time object" do
      DateTime.now.to_time.should be_kind_of(Time)
    end

    it "preserves the same time regardless of local time or zone" do
      with_timezone("Pactific/Pago_Pago", -11) do
        date = DateTime.new(2012, 12, 24, 12, 23, 00, '+03:00')
        time = date.to_time

        time.year.should == date.year
        time.mon.should == date.mon
        time.day.should == date.day
        time.hour.should == date.hour
        time.min.should == date.min
        time.sec.should == date.sec
      end
    end
  end
end
