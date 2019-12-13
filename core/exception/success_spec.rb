require_relative '../../spec_helper'

describe "SystemExit#success?" do
  it "returns the exit status" do
    -> { exit }.should raise_error(SystemExit) { |e|
      e.success?.should == true
    }
  end
end
