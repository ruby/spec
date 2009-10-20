require File.dirname(__FILE__) + '/../../spec_helper'
require 'matrix'

describe "Matrix#row" do
  before :all do
    @m = Matrix[ [1, 2], [1, 2] ]
  end

  it "returns a Vector when called without a block" do
    @m.row(0).should == Vector[1,2]
  end

  ruby_bug "redmine:1532", "1.8.7" do
    it "returns self when called with a block" do
      @m.row(0) { |x| x }.should equal(@m)
    end

    it "returns nil when out of bounds" do
      @m.row(2).should == nil
    end
  end
end