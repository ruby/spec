require_relative '../../spec_helper'

describe "Time#ctime" do
  it "returns a canonical string representation of time" do
    t = Time.now
    t.ctime.should == t.strftime("%a %b %e %H:%M:%S %Y")
  end
end
