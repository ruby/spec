require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/methods'

describe "Time#_dump" do
  before :each do
    @t = Time.local(2000, 1, 15, 20, 1, 1)
    @s = @t._dump
    @t = @t.gmtime
  end
  
  it "dumps a Time object to a bytestring" do
    @s.should be_kind_of(String)
    @s.should == [2149122561, 68157440].pack("LL")
  end

  it "dumps an array with a date as first element" do
    high =                1 << 31 |
           (@t.year - 1900) << 14 |
              (@t.mon  - 1) << 10 |
                     @t.mday << 5 |
                     @t.hour

    high.should == @s.unpack("LL").first
  end


  it "dumps an array with a time as second element" do
    low =  @t.min  << 26 |
           @t.sec  << 20 |
           @t.usec
    low.should == @s.unpack("LL").last
  end
end
