require_relative '../../spec_helper'

describe "ENV.replace" do
  it "replaces ENV with a Hash" do
    orig = ENV.to_hash
    begin
      ENV.replace("foo" => "0", "bar" => "1").should equal(ENV)
      ENV.size.should == 2
      ENV["foo"].should == "0"
      ENV["bar"].should == "1"
    ensure
      ENV.replace(orig)
      ENV.size.should == orig.size
    end
  end

end
