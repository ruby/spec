require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'

describe "Array#assoc" do
  it "returns the first array whose 1st item is == obj or nil" do
    s1 = ["colors", "red", "blue", "green"] 
    s2 = [:letters, "a", "b", "c"]
    s3 = [4]
    s4 = ["colors", "cyan", "yellow", "magenda"]
    s5 = [:letters, "a", "i", "u"]
    s_nil = [nil, nil]
    a = [s1, s2, s3, s4, s5, s_nil]
    a.assoc(s1.first).equal?(s1).should be_true
    a.assoc(s2.first).equal?(s2).should be_true
    a.assoc(s3.first).equal?(s3).should be_true
    a.assoc(s4.first).equal?(s1).should be_true
    a.assoc(s5.first).equal?(s2).should be_true
    a.assoc(s_nil.first).equal?(s_nil).should be_true
    a.assoc(4).equal?(s3).should be_true
    a.assoc("key not in array").should == nil
  end

  it "calls == on first element of each array" do
    key1 = 'it'
    key2 = mock('key2')
    items = [['not it', 1], [ArraySpecs::AssocKey.new, 2], ['na', 3]]

    items.assoc(key1).should == items[1]
    items.assoc(key2).should == nil
  end
  
  it "ignores any non-Array elements" do
    [1, 2, 3].assoc(2).should == nil
    s1 = [4]
    s2 = [5, 4, 3]
    a = ["foo", [], s1, s2, nil, []] 
    a.assoc(s1.first).should == s1
    a.assoc(s2.first).should == s2
  end
end
