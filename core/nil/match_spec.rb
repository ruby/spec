require_relative '../../spec_helper'

describe "NilClass#=~" do
  it "returns nil matching any object" do
    (nil =~ /Object/).should   be_nil
    (nil =~ 'Object').should   be_nil
    (nil =~ Object).should     be_nil
    (nil =~ Object.new).should be_nil
    (nil =~ nil).should        be_nil
    (nil =~ false).should      be_nil
    (nil =~ true).should       be_nil
  end

  it "should not warn" do
    -> { nil =~ /a/ }.should_not complain(verbose: true)
  end
end
