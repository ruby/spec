require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'

describe "Kernel#exit" do
  it "is a private method" do
    Kernel.should have_private_instance_method(:exit)
  end
end

describe "Kernel#exit!" do
  it "is a private method" do
    Kernel.should have_private_instance_method(:exit!)
  end
end

describe "Kernel.exit" do
  it "raises a SystemExit with status 0" do
    begin
      exit
      ScratchPad.record :no_exit
    rescue SystemExit => e
      e.status.should == 0
    end
    ScratchPad.recorded.should be_nil
  end

  it "raises a SystemExit with the specified status" do
    [-2**16, -2**8, -8, -1, 0, 1 , 8, 2**8, 2**16].each { |value|
      begin
        exit(value)
        ScratchPad.record :no_exit
      rescue SystemExit => e
        e.status.should == value
      end
      ScratchPad.recorded.should be_nil
    }
  end
end

describe "Kernel.exit!" do
  it "needs to be reviewed for spec completeness"
end
