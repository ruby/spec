require File.expand_path('../spec_helper', __FILE__)
require 'java' if RUBY_PLATFORM =~ /java/

describe "Managed Struct" do
  module LibTest
    extend Library
    ffi_lib TestLibrary::PATH
    attach_function :ptr_from_address, [ Platform::ADDRESS_SIZE == 32 ? :uint : :ulong_long ], :pointer
  end

  it "should raise an error if release() is not defined" do
    class NoRelease < ManagedStruct ; layout :i, :int; end
    lambda { NoRelease.new(LibTest.ptr_from_address(0x12345678)) }.should raise_error(NoMethodError)
  end

  it "should be the right class" do
    class WhatClassAmI < ManagedStruct
      layout :i, :int
      def self.release; end
    end

    WhatClassAmI.new(LibTest.ptr_from_address(0x12345678)).class.should == WhatClassAmI
  end

  it "should release memory properly" do
    class PleaseReleaseMe < ManagedStruct
      layout :i, :int
      @@count = 0
      def self.release
        @@count += 1
      end
      def self.wait_gc(count)
        loop = 5
        while loop > 0 && @@count < count
          loop -= 1
          if RUBY_PLATFORM =~ /java/
            java.lang.System.gc
          else
            GC.start
          end
          sleep 0.05 if @@count < count
        end
      end
    end

    loop_count = 30
    wiggle_room = 2

    PleaseReleaseMe.should_receive(:release).at_least(loop_count-wiggle_room).times
    loop_count.times do
      s = PleaseReleaseMe.new(LibTest.ptr_from_address(0x12345678))
    end
    PleaseReleaseMe.wait_gc loop_count
  end
end
