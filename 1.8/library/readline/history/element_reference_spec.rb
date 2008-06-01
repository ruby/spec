require File.dirname(__FILE__) + '/../../../spec_helper'
require 'readline'

describe "Readline::HISTORY.[]" do
  before(:each) do
    Readline::HISTORY.push("1", "2", "3")
  end
  
  after(:each) do
    Readline::HISTORY.pop
    Readline::HISTORY.pop
    Readline::HISTORY.pop
  end

  it "returns the history item at the passed index + 1" do
    Readline::HISTORY[0].should == "2"
    Readline::HISTORY[1].should == "3"
    
    # NOTE: This is weird behaviour!
    # One would expect -1 to return "3"
    Readline::HISTORY[-2].should == "3"
    Readline::HISTORY[-3].should == "2"
    Readline::HISTORY[-4].should == "1"
  end
  
  it "returns tainted objects" do
    Readline::HISTORY[0].tainted?.should be_true
    Readline::HISTORY[1].tainted?.should be_true
  end

  it "returns the first item for negative values when there is no item at the passed index" do
    # NOTE: This is weird behaviour!
    # One would expect these to raise an IndexError
    Readline::HISTORY[-10].should == "1"
    Readline::HISTORY[-9].should == "1"
    Readline::HISTORY[-8].should == "1"
  end
  
  it "raises an IndexError when there is no item at the passed index" do
    lambda { Readline::HISTORY[-1] }.should raise_error(IndexError)
    lambda { Readline::HISTORY[10] }.should raise_error(IndexError)
  end
end
