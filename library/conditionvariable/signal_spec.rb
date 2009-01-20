require File.dirname(__FILE__) + '/../../spec_helper'
require 'thread'

describe "ConditionVariable#signal" do
  it "should return self if nothing to signal" do
    cv = ConditionVariable.new
    cv.signal.should == cv
  end

  it "should return self if something is waiting for signal" do
    m = Mutex.new
    cv = ConditionVariable.new
    th = Thread.new do
      m.synchronize do
        cv.wait(m)
      end
    end

    # ensures that th grabs m before current thread
    Thread.pass until th.status == "sleep"

    m.synchronize { cv.signal }.should == cv
  end

  it "wakes up the first thread waiting in line for this resource" do
    m = Mutex.new
    cv = ConditionVariable.new
    r1 = []
    r2 = []

    # large number to attempt to cause race conditions
    threads = (0..100).map do |i|
      Thread.new(i) do |tid|
        m.synchronize do
          r1 << tid
          cv.wait(m)
          r2 << tid
        end
      end
    end

    # wait for all threads to acquire the mutex the first time
    Thread.pass until m.synchronize { r1.size == threads.size }
    # wait until all threads are sleeping (ie waiting)
    Thread.pass until threads.all? {|th| th.status == "sleep" }

    m.synchronize do
      r2.should be_empty
      threads.each { cv.signal }
    end

    threads.each {|t| t.join }

    # ensure that all the threads that went into the cv.wait came out of it
    r2.sort.should == r1.sort
  end
end
