require File.dirname(__FILE__) + '/../../spec_helper'
require 'matrix'

describe "Matrix.[]" do
  it "accepts only arrays as parameters" do
    lambda { Matrix[5] }.should raise_error(TypeError)
    lambda { Matrix[nil] }.should raise_error(TypeError)
    lambda { Matrix[1..2] }.should raise_error(TypeError)
    lambda { Matrix[[1, 2], 3] }.should raise_error(TypeError)
  end

  it "returns an object of type Matrix" do
    Matrix[ [1, 2], [3, 4] ].should be_an_instance_of(Matrix)
  end

  it "doesn't require an argument" do
    Matrix[].should be_an_instance_of(Matrix)
  end

  it "accepts an empty row" do
    Matrix[[]].should be_an_instance_of(Matrix)
  end

  it "accepts vector arguments" do
    a = Matrix[Vector[1, 2], Vector[3, 4]]
    a.should be_an_instance_of(Matrix)
    a.should == Matrix[ [1, 2], [3, 4] ]
  end

  it "accepts arrays of different sizes" do
    Matrix[ [1, 2], [3, 4, 5] ].should be_an_instance_of(Matrix)
  end
end
