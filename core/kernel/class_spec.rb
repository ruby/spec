require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

describe "Kernel#class" do
  it "returns Class for a Class" do
    BasicObject.class.should equal(Class)
    String.class.should equal(Class)
  end
end
