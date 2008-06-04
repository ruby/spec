require File.dirname(__FILE__) + '/../../spec_helper'
require 'readline'

describe "Readline::HISTORY" do
  it "Readline::HISTORY is a Enumerable" do
    Readline::HISTORY.is_a?(Enumerable).should == true
  end
end

describe "Readline#readline" do
  it "needs to be reviewed for spec completeness" do
  end
end

describe "Readline.readline" do
  it "needs to be reviewed for spec completeness" do
  end
end
