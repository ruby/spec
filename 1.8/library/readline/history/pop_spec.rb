require File.dirname(__FILE__) + '/../../../spec_helper'
require 'readline'

describe "Readline::HISTORY.pop" do
  it "returns nil when the history is empty" do
    Readline::HISTORY.pop.should be_nil
  end
  
  it "returns the last item of the history" do
    Readline::HISTORY.push("test")
    Readline::HISTORY.pop.should == "test"
  end
  
  it "removes the item from the history" do
    Readline::HISTORY.push("test")
    Readline::HISTORY.size.should == 1
    
    Readline::HISTORY.pop
    Readline::HISTORY.size.should == 0
  end
end
