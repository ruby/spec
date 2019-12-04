require_relative '../../spec_helper'

describe "SystemExit#status" do
  it "returns the exit status" do
    -> { exit }.should raise_error(SystemExit) { |e|
      e.status.should == 0
    }
  end
end
