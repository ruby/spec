describe :time_tz, shared: true do
  describe "TZ env variable" do
    # We don't check #zone because it returns planform specific abbreviations
    # e.g. "a/H" or "Asi" for "Asia/Hong_Kong" or "Coordinated Universal Time" for "UTC"
    # on Windows
    #
    # see https://bugs.ruby-lang.org/issues/13591#note-11

    before do
      @tz = ENV["TZ"]

      @get_time = @object
    end

    after do
      ENV["TZ"] = @tz
    end

    it "returns time in timezone specified by TZ env variable" do
      ENV["TZ"] = "Asia/Hong_Kong"
      @get_time.call.utc_offset.should == 8*60*60 # HKT, +08:00

      ENV["TZ"] = "Africa/Dakar"
      @get_time.call.utc_offset.should == 0 # "GMT"
    end

    it "returns time in UTC if specified incorrect value" do
      ENV["TZ"] = "bla-bla-bla"
      @get_time.call.utc_offset.should == 0

      ENV["TZ"] = ""
      @get_time.call.utc_offset.should == 0

      ENV["TZ"] = "  "
      @get_time.call.utc_offset.should == 0
    end

    # We cannot compare with system time zone as far as this check will fail
    # if TZ is already set and doesn't equal system time zone
    it "returns time in local timezone if specified nil" do
      ENV["TZ"] = nil
      @get_time.call.zone.should_not == nil
    end
  end
end
