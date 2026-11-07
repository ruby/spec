require_relative '../../spec_helper'

describe 'Binding#local_variable_defined?' do
  it 'returns false when a variable is not defined' do
    binding.local_variable_defined?(:foo).should == false
  end

  it 'returns true when a regular local variable is defined' do
    foo = 10
    binding.local_variable_defined?(:foo).should == true
  end

  it 'returns true when a local variable is defined using eval()' do
    bind = binding
    bind.eval('foo = 10')

    bind.local_variable_defined?(:foo).should == true
  end

  it 'returns true when a local variable is defined using Binding#local_variable_set' do
    bind = binding
    bind.local_variable_set(:foo, 10)

    bind.local_variable_defined?(:foo).should == true
  end

  it 'returns true when a local variable is defined in a parent scope' do
    foo = 10
    -> {
      binding.local_variable_defined?(:foo)
    }.call.should == true
  end

  it 'allows usage of a String as the variable name' do
    foo = 10
    binding.local_variable_defined?('foo').should == true
  end

  it 'allows usage of an object responding to #to_str as the variable name' do
    foo  = 10
    name = mock(:obj)
    name.stub!(:to_str).and_return('foo')

    binding.local_variable_defined?(name).should == true
  end

  it 'raises a TypeError when given non-String/Symbol as the variable name' do
    -> {
      binding.local_variable_defined?(1)
    }.should.raise(TypeError, '1 is not a symbol nor a string')
  end

  ruby_version_is "4.0" do
    it "raises a NameError for numbered parameters" do
      -> {
        proc { _1; binding.local_variable_defined?(:_1) }.call(1)
      }.should.raise(NameError, /numbered parameter '_1' is not a local variable/)
    end

    it "returns false for the \"it\" parameter" do
      eval("proc { it; binding.local_variable_defined?(:it) }").call(1).should == false
    end
  end
end
