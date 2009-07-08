require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'

describe "Module#name" do
  ruby_version_is ""..."1.9" do
    it "returns an empty String by default" do
      Module.new.name.should == ""
      Class.new.name.should == ""
    end
  end

  ruby_version_is "1.9" do
    it "returns nil by default" do
      Module.new.name.should be_nil
      Class.new.name.should be_nil
    end
  end

  it "returns the name of self" do

    ModuleSpecs.name.should == "ModuleSpecs"
    ModuleSpecs::Child.name.should == "ModuleSpecs::Child"
    ModuleSpecs::Parent.name.should == "ModuleSpecs::Parent"
    ModuleSpecs::Basic.name.should == "ModuleSpecs::Basic"
    ModuleSpecs::Super.name.should == "ModuleSpecs::Super"
    
    begin
      (ModuleSpecs::X = Module.new).name.should == "ModuleSpecs::X"
    ensure
      ModuleSpecs.send :remove_const, :X
    end
  end
end
