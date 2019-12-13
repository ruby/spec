require_relative '../../spec_helper'

describe "SignalException#signm" do
  it "returns the signal name" do
    name = Signal.list.keys.last
    -> { Process.kill(name, Process.pid) }.should raise_error(SignalException) { |e|
      e.signm.should == 'SIG' + name
    }
  end
end
