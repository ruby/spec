require File.dirname(__FILE__) + '/../../spec_helper'
require 'readline'

describe "Readline::HISTORY" do
  it "is defined" do
    Readline.const_defined?(:HISTORY).should == true
  end
end

describe "Readline::VERSION" do
  it "is defined and is a non-empty String" do
    Readline.const_defined?(:VERSION).should == true
    Readline::VERSION.class == String
    Readline::VERSION.empty?.should == false
  end
end
