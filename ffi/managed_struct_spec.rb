require File.expand_path('../spec_helper', __FILE__)

module FFISpecs
  describe "Managed Struct" do
    it "should raise an error if release() is not defined" do
      lambda {
        NoRelease.new(LibTest.ptr_from_address(0x12345678))
      }.should raise_error(NoMethodError)
    end

    it "should be the right class" do
      ptr = WhatClassAmI.new(LibTest.ptr_from_address(0x12345678))
      ptr.should be_kind_of(WhatClassAmI)
    end

    it "should release memory properly" do
      loop_count = 30
      wiggle_room = 2

      PleaseReleaseMe.should_receive(:release).at_least(loop_count - wiggle_room).times
      loop_count.times do
        s = PleaseReleaseMe.new(LibTest.ptr_from_address(0x12345678))
      end

      PleaseReleaseMe.wait_gc loop_count
    end
  end
end