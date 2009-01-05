require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../fixtures/class_variables'

describe "A Class Variable" do
  it "can be accessed from a subclass" do
    ClassVariablesSpec::ClassB.new.cvar_a.should == :cvar_a
  end

  it "is set in the superclass" do
    a = ClassVariablesSpec::ClassA.new
    b = ClassVariablesSpec::ClassB.new
    b.cvar_a = :new_val

    a.cvar_a.should == :new_val
  end
end

describe "A Class Variable defined in a Module" do
  it "can be accessed from Classes that extend the Module" do
    ClassVariablesSpec::ClassC.cvar_m.should == :value
  end
  
  it "is not defined in these Classes" do
    ClassVariablesSpec::ClassC.cvar_defined?.should be_false
  end
  
  it "is only updated in the Module a Method defined in the Module is used" do
    ClassVariablesSpec::ClassC.cvar_m = "new value"
    ClassVariablesSpec::ClassC.cvar_m.should == "new value"
    
    ClassVariablesSpec::ClassC.cvar_defined?.should be_false
  end
  
  it "is updated in the Class when a Method defined in the Class is used" do
    ClassVariablesSpec::ClassC.cvar_c = "new value"    
    ClassVariablesSpec::ClassC.cvar_defined?.should be_true
  end

  it "can be accessed inside the Class using the Module methods" do
    ClassVariablesSpec::ClassC.cvar_c = "new value"

    ClassVariablesSpec::ClassC.cvar_m.should == "new value"
  end
end
