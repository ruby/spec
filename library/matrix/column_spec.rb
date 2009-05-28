require File.dirname(__FILE__) + '/../../spec_helper'
require 'matrix'

describe "Matrix#column" do
  before :all do
    @m =  Matrix[[1,2],[1,2]]
  end

  it "returns a Vector when called without a block" do
    @m.column(1).should == Vector[2,2]
  end

  it "yields each element in the column to the block" do
    @m.column(1) do |n|
      n.should == 2
    end
  end
  
  it "returns nil when out of bounds" do
    @m.column(2).should == nil
  end
end