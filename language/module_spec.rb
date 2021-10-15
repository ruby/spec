require_relative '../spec_helper'
require_relative 'fixtures/module'

describe "The module keyword" do
  it "creates a new module without semicolon" do
    module ModuleSpecsKeywordWithoutSemicolon end
    ModuleSpecsKeywordWithoutSemicolon.should be_an_instance_of(Module)
  end

  it "creates a new module with a non-qualified constant name" do
    module ModuleSpecsToplevel; end
    ModuleSpecsToplevel.should be_an_instance_of(Module)
  end

  it "creates a new module with a qualified constant name" do
    module ModuleSpecs::Nested; end
    ModuleSpecs::Nested.should be_an_instance_of(Module)
  end

  it "creates a new module with a variable qualified constant name" do
    m = Module.new
    module m::N; end
    m::N.should be_an_instance_of(Module)
  end

  it "reopens an existing module" do
    module ModuleSpecs; Reopened = true; end
    ModuleSpecs::Reopened.should be_true
  end

  it "reopens a module included in Object" do
    module IncludedModuleSpecs; Reopened = true; end
    ModuleSpecs::IncludedInObject::IncludedModuleSpecs::Reopened.should be_true
  end

  it "raises a TypeError if the constant is a Class" do
    -> do
      module ModuleSpecs::Modules::Klass; end
    end.should raise_error(TypeError)
  end

  it "raises a TypeError if the constant is a String" do
    -> { module ModuleSpecs::Modules::A; end }.should raise_error(TypeError)
  end

  it "raises a TypeError if the constant is an Integer" do
    -> { module ModuleSpecs::Modules::B; end }.should raise_error(TypeError)
  end

  it "raises a TypeError if the constant is nil" do
    -> { module ModuleSpecs::Modules::C; end }.should raise_error(TypeError)
  end

  it "raises a TypeError if the constant is true" do
    -> { module ModuleSpecs::Modules::D; end }.should raise_error(TypeError)
  end

  it "raises a TypeError if the constant is false" do
    -> { module ModuleSpecs::Modules::D; end }.should raise_error(TypeError)
  end
end

describe "Assigning an anonymous module to a constant" do
  it "sets the name of the module" do
    mod = Module.new
    mod.name.should be_nil

    ::ModuleSpecs_CS1 = mod
    mod.name.should == "ModuleSpecs_CS1"
  end

  ruby_version_is ""..."3.0" do
    it "does not set the name of a module scoped by an anonymous module" do
      a, b = Module.new, Module.new
      a::B = b
      b.name.should be_nil
    end
  end

  ruby_version_is "3.0" do
    it "sets the name of a module scoped by an anonymous module" do
      a, b = Module.new, Module.new
      a::B = b
      b.name.should.end_with? '::B'
    end
  end

  it "sets the name of contained modules when assigning a toplevel anonymous module" do
    a, b, c, d = Module.new, Module.new, Module.new, Module.new
    a::B = b
    a::B::C = c
    a::B::C::E = c
    a::D = d

    ::ModuleSpecs_CS2 = a
    a.name.should == "ModuleSpecs_CS2"
    b.name.should == "ModuleSpecs_CS2::B"
    c.name.should == "ModuleSpecs_CS2::B::C"
    d.name.should == "ModuleSpecs_CS2::D"
  end
end

ruby_version_is "3.0" do
  describe "Include" do
    context "when the include in the module is done after the include in the class" do
      it "includes the M1 and M2 module" do
        class A; end
        module B1; end
        module C2; end

        A.include B1
        B1.include C2
        A.ancestors.should == [A, B1, C2, Object, ModuleSpecs::IncludedInObject, PP::ObjectMixin, Kernel, BasicObject]
      end
    end

    context "when the include in the module is done before the include in the class" do
      it "includes the M1 and M2 module" do
        class D; end
        module E1; end
        module F2; end

        E1.include F2
        D.include E1
        D.ancestors.should == [D, E1, F2, Object, ModuleSpecs::IncludedInObject, PP::ObjectMixin, Kernel, BasicObject]
      end
    end
  end

  describe "Prepend" do
    context "when the include in the module is done after the include in the class" do
      it "includes the M1 and M2 module" do
        class G; end
        module H1; end
        module I2; end

        G.prepend H1
        H1.prepend I2
        G.ancestors.should == [I2, H1, G, Object, ModuleSpecs::IncludedInObject, PP::ObjectMixin, Kernel, BasicObject]
      end
    end

    context "when the include in the module is done before the include in the class" do
      it "includes the M1 and M2 module" do
        class J; end
        module K1; end
        module L2; end

        K1.prepend L2
        J.prepend K1
        J.ancestors.should == [L2, K1, J, Object, ModuleSpecs::IncludedInObject, PP::ObjectMixin, Kernel, BasicObject]
      end
    end
  end
end
