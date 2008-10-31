require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'

describe "Array#delete_if" do
  before do
    @a = [ "a", "b", "c" ] 
  end

  it "removes each element for which block returns true" do
    @a.delete_if { |x| x >= "b" }
    @a.should == ["a"]
  end

  it "returns self" do
    @a.delete_if{ true }.equal?(@a).should be_true
  end

  it "returns an Enumerator if no block given, and the enumerator can modify the original array" do
    enum = @a.delete_if
    enum.should be_kind_of(Enumerator)
    @a.should_not be_empty
    enum.each { true }
    @a.should be_empty
  end

  compliant_on :ruby, :jruby do
    it "raises a RuntimeError on a frozen array" do
      lambda { ArraySpecs.frozen_array.delete_if {} }.should raise_error(RuntimeError)
    end
  end

  it "keeps tainted status" do
    @a.taint
    @a.tainted?.should be_true
    @a.delete_if{ true }
    @a.tainted?.should be_true
  end

  it "keeps untrusted status" do
    @a.untrust
    @a.untrusted?.should be_true
    @a.delete_if{ true }
    @a.untrusted?.should be_true
  end
end
