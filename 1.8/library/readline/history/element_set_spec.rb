require File.dirname(__FILE__) + '/../../../spec_helper'
require 'readline'

describe "Readline::HISTORY.[]=" do
  before(:each) do
    Readline::HISTORY.push("1", "2", "3")
  end
  
  after(:each) do
    Readline::HISTORY.pop
    Readline::HISTORY.pop
    Readline::HISTORY.pop
  end
  
  it "sets the item at the given index" do
    # NOTE: Wow, now this is scary!
    # I can set the item at position 0, but not retrieve it?!
    Readline::HISTORY[0] = "test"
    Readline::HISTORY[-4].should == "test"

    # NOTE: This must be a bug....
    Readline::HISTORY[1] = "second test"
    Readline::HISTORY[1].should == "3"

    # NOTE: Madness??? THIS IS RUBY!
    Readline::HISTORY[-20] = "third test"
    Readline::HISTORY[-4].should == "third test"
  end
  
  it "returns the new value for the passed index" do
    (Readline::HISTORY[1] = "second test").should == "second test"
  end

  it "raises an IndexError when there is no item at the passed index" do
    lambda { Readline::HISTORY[10] = "test" }.should raise_error(IndexError)
  end
end
