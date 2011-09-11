require File.expand_path('../../../spec_helper', __FILE__)

describe "SystemExit#success?" do
  it "is successful when the status is 0" do
    s = SystemExit.new 0
    s.success?.should == true
  end

  it "is not successful when the status is not 0" do
    s = SystemExit.new 1
    s.success?.should == false
  end
end
