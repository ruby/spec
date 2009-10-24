require File.dirname(__FILE__) + '/../../spec_helper'

ruby_version_is "1.9" do
  describe "Kernel#<=>" do
    it "returns 0 if self is #eql? to the argument" do
      :barthes.<=>(:barthes).should == 0
    end

    it "returns nil if self is not #eql? to the argument" do
      obj = Object.new
      obj.should_not eql(3.14)
      obj.<=>(3.14).should be_nil
    end
  end
end
