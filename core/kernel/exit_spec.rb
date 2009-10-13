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
    exception = nil
    begin
      exit
    rescue SystemExit => e
      exception = e
    end
    exception.status.should == 0
  end
  
  it "raises a SystemExit with the specified status" do
    exception = nil
    begin
      exit(9)
    rescue SystemExit => e
      exception = e
    end
    exception.status.should == 9
  end
end

describe "Kernel.exit!" do
  it "needs to be reviewed for spec completeness"
end
