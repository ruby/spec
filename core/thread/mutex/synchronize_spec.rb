require_relative '../../../spec_helper'

describe "Mutex#synchronize" do
  it "wraps the lock/unlock pair in an ensure" do
    m1 = Thread::Mutex.new
    m2 = Thread::Mutex.new
    m2.lock
    synchronized = false

    th = Thread.new do
      -> do
        m1.synchronize do
          synchronized = true
          m2.lock
          raise Exception
        end
      end.should raise_error(Exception)
    end

    Thread.pass until synchronized

    m1.locked?.should be_true
    m2.unlock
    th.join
    m1.locked?.should be_false
  end

  it "blocks the caller if already locked" do
    m = Thread::Mutex.new
    m.lock
    -> { m.synchronize { } }.should block_caller
  end

  it "does not block the caller if not locked" do
    m = Thread::Mutex.new
    -> { m.synchronize { } }.should_not block_caller
  end

  it "blocks the caller if another thread is also in the synchronize block" do
    m = Thread::Mutex.new
    q1 = Thread::Queue.new
    q2 = Thread::Queue.new

    t = Thread.new {
      m.synchronize {
        q1.push :ready
        q2.pop
      }
    }

    q1.pop.should == :ready

    -> { m.synchronize { } }.should block_caller

    q2.push :done
    t.join
  end

  it "is not recursive" do
    m = Thread::Mutex.new

    m.synchronize do
      -> { m.synchronize { } }.should raise_error(ThreadError)
    end
  end
end
