require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'

describe "Kernel#abort" do
  it "is a private method" do
    Kernel.should have_private_instance_method(:abort)
  end
end

describe "Kernel.abort" do

  it "needs to be reviewed for spec completeness"

  it "raises a SystemExit" do
    lambda { abort }.should raise_error SystemExit
  end

  it "gives a status code of 1" do
    lambda { abort }.should raise_error { |e| e.status.should == 1 }
  end

  it "propogates the specified message" do
    lambda { abort "a message" }.should raise_error Exception, "a message"
  end
end
