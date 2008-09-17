require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/methods'

describe "Time#_dump" do
  it "dumps a time object" do
    t = Time.local(2000, 1, 15, 20, 1, 1)
    s = t._dump

    t = t.gmtime
    
    high =               1 << 31 |
           (t.year - 1900) << 14 |
              (t.mon  - 1) << 10 |
                    t.mday << 5 |
                    t.hour

    low =  t.min  << 26 |
           t.sec  << 20 |
           t.usec

    s.should == [high, low].pack("LL")
  end
end