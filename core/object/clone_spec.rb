require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/shared/dup_clone'

describe "Object#clone" do
  it_behaves_like :object_dup_clone, :clone

  it "preserves frozen state from the original" do
    o = ObjectSpecDupInitCopy.new
    o2 = o.clone
    o.freeze
    o3 = o.clone

    o2.frozen?.should == false
    o3.frozen?.should == true
  end

  it "preserves tainted state from the original" do
    o = ObjectSpecDupInitCopy.new
    o2 = o.clone
    o.taint
    o3 = o.clone

    o2.tainted?.should == false
    o3.tainted?.should == true
  end

  ruby_version_is "1.9" do
    it "preserves untrusted state from the original" do
      o = ObjectSpecDupInitCopy.new
      o2 = o.clone
      o.untrust
      o3 = o.clone

      o2.untrusted?.should == false
      o3.untrusted?.should == true
    end
  end
end

