require_relative '../../spec_helper'

describe "SignalException#signo" do
  it "returns the signal number" do
    name = Signal.list.keys.last
    number = Signal.list[name]
    -> { Process.kill(name, Process.pid) }.should raise_error(SignalException) { |e|
      e.signo.should == number
    }
  end
end
