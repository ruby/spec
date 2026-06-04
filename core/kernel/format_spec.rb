require_relative '../../spec_helper'
require_relative 'fixtures/classes'

# NOTE: most specs are in sprintf_spec.rb, this is just an alias
describe "Kernel#format" do
  it "is a private method" do
    Kernel.private_instance_methods(false).should.include?(:format)
  end
end

describe "Kernel.format" do
  it "is accessible as a module function" do
    Kernel.format("%s", "hello").should == "hello"
  end
end
