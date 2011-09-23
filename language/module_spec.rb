require File.expand_path('../../spec_helper', __FILE__)

module LangModuleSpec
  module Sub1; end

  module AnonymousModules
    # used as a container for anonymous module specs testing const assignment
  end
end

module LangModuleSpecInObject
  module LangModuleTop
  end
end

# Must be here, we have to include it into Object because thats
# the case.
include LangModuleSpecInObject

module LangModuleSpec::Sub2; end

describe "module" do
  it "has the right name" do
    LangModuleSpec::Sub1.name.should == "LangModuleSpec::Sub1"
    LangModuleSpec::Sub2.name.should == "LangModuleSpec::Sub2"
  end

  it "gets a name when assigned to a constant" do
    LangModuleSpec::Anon = Module.new
    LangModuleSpec::Anon.name.should == "LangModuleSpec::Anon"
  end

  it "raises a TypeError if the constant is a class" do
    class LangModuleSpec::C1; end

    lambda {
      module LangModuleSpec::C1; end
    }.should raise_error(TypeError)
  end

  it "raises a TypeError if the constant is not a module" do
    module LangModuleSpec
      C2 = 2
    end

    lambda {
      module LangModuleSpec::C2; end
    }.should raise_error(TypeError)
  end

  it "allows for reopening a module subclass" do
    class ModuleSubClass < Module; end
    LangModuleSpec::C3 = ModuleSubClass.new

    module LangModuleSpec::C3
      C4 = 4
    end

    LangModuleSpec::C3::C4.should == 4
  end

  it "reopens a module included into Object" do
    module LangModuleTop
    end

    LangModuleTop.should == LangModuleSpecInObject::LangModuleTop
  end
end

describe "An anonymous module" do
  ruby_version_is "" ... "1.9" do
    it "returns an empty string for its name" do
      m = Module.new
      m.name.should == ""
    end
  end

  ruby_version_is "1.9" do
    it "returns nil for its name" do
      m = Module.new
      m.name.should == nil
    end
  end

  it "takes on the name of the first constant it is assigned to" do
    c1 = Module.new
    c1.inspect.should =~ /#<Module/
    LangModuleSpec::AnonymousModules::C1 = c1
    c1.inspect.should == "LangModuleSpec::AnonymousModules::C1"

    c2 = Module.new
    LangModuleSpec::AnonymousModules.const_set :C2, c2
    c2.inspect.should == "LangModuleSpec::AnonymousModules::C2"
  end

  it "forces named nested modules to be anonymous" do
    c3 = Module.new
    c3.const_set :C4, Module.new

    c3::C4.inspect.should =~ /#<Module/

    LangModuleSpec::AnonymousModules::C3 = c3
    c3::C4.inspect.should == "LangModuleSpec::AnonymousModules::C3::C4"

    c5 = Module.new
    c5.const_set :C6, Module.new

    LangModuleSpec::AnonymousModules.const_set :C5, c5
    c5::C6.inspect.should == "LangModuleSpec::AnonymousModules::C5::C6"
  end

  it "never recalculates full name once no longer anonymous" do
    c6 = Module.new
    c6.const_set :C7, Module.new
    LangModuleSpec::AnonymousModules::C6 = c6
    c6::C7.inspect.should == "LangModuleSpec::AnonymousModules::C6::C7"

    LangModuleSpec::AnonymousModules::C8 = c6::C7
    LangModuleSpec::AnonymousModules::C8.inspect.should == "LangModuleSpec::AnonymousModules::C6::C7"
  end
end
