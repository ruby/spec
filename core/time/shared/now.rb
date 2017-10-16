require File.expand_path('../../fixtures/classes', __FILE__)

describe :time_now, shared: true do
  it "creates a subclass instance if called on a subclass" do
    TimeSpecs::SubTime.send(@method).should be_an_instance_of(TimeSpecs::SubTime)
    TimeSpecs::MethodHolder.send(@method).should be_an_instance_of(Time)
  end

  it "sets the current time" do
    check = `date "+%H:%M:%S"`.strip
    time = check.match(/(\d{2})\:(\d{2})\:(\d{2})/)
    now = TimeSpecs::MethodHolder.send(@method)

    now.hour.should == time[1].to_i
    now.min.should == time[2].to_i
    now.sec.should == time[3].to_i
  end

  it "preserves the local timezone" do
    with_timezone("PDT", -8) do
      now = TimeSpecs::MethodHolder.send(@method)
      now.utc_offset.should == (-8 * 60 * 60)
    end
  end
end
