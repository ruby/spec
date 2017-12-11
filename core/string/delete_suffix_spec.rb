# -*- encoding: utf-8 -*-
require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes.rb', __FILE__)

describe "String#delete_suffix" do
  it "returns a copy of the string, with the given prefix" do
    'hello'.delete_suffix('ello').should == 'h'
    'hello'.delete_suffix('hello').should == ''
    'hello'.delete_suffix('!hello').should == 'hello'
    'hello'.delete_suffix('ell').should == 'hello'
    'hello'.delete_suffix('').should == 'hello'
  end

  it "taints resulting strings when other is tainted" do
    'hello'.taint.delete_suffix('ello').tainted?.should == true
    'hello'.taint.delete_suffix('').tainted?.should == true
  end

  it "doesn't set $~" do
    $~ = nil

    'hello'.delete_suffix('ello')
    $~.should == nil
  end

  it "calls to_str on its argument" do
    o = mock('x')
    o.should_receive(:to_str).and_return 'ello'
    'hello'.delete_suffix(o).should == 'h'
  end

  it "returns a subclass instance when called on a subclass instance" do
    s = StringSpecs::MyString.new('hello')
    s.delete_prefix('ello').should be_an_instance_of(StringSpecs::MyString)
  end
end

describe "String#delete_suffix!" do
  it "removes the found prefix" do
    s = 'hello'
    s.delete_suffix!('ello').should equal(s)
    s.should == 'h'
  end

  it "returns nil if no change is made" do
    s = 'hello'
    s.delete_suffix!('ell').should == nil
    s.delete_suffix!('').should == nil
  end

  it "doesn't set $~" do
    $~ = nil

    'hello'.delete_suffix!('ello')
    $~.should == nil
  end

  it "calls to_str on its argument" do
    o = mock('x')
    o.should_receive(:to_str).and_return 'ello'
    'hello'.delete_suffix!(o).should == 'h'
  end

  it "raises a RuntimeError when self is frozen" do
    lambda { 'hello'.freeze.delete_suffix!('ello') }.should raise_error(RuntimeError)
    lambda { 'hello'.freeze.delete_suffix!('') }.should raise_error(RuntimeError)
    lambda { ''.freeze.delete_suffix!('') }.should raise_error(RuntimeError)
  end
end
