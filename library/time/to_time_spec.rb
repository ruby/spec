require File.expand_path('../../../spec_helper', __FILE__)
require 'time'

ruby_version_is "2.4" do
  describe "Time#to_time" do
    it "returns itself in the same timezone" do
      with_timezone("America/Regina") do
        time = Time.new(2012, 2, 21, 10, 11, 12)
        time.to_time.should == time
      end

      time2 = Time.utc(2012, 2, 21, 10, 11, 12)
      time2.to_time.should == time2
    end
  end
end
