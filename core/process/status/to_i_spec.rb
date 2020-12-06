require_relative '../../../spec_helper'

describe "Process::Status#to_i" do
  it "returns an integer when the child exits" do
    ruby_exe('exit 48', exception: false)
    $?.to_i.should be_an_instance_of(Integer)
  end

  it "returns an integer when the child is signaled" do
    ruby_exe('raise SignalException, "TERM"', exception: false)
    $?.to_i.should be_an_instance_of(Integer)
  end
end
