require File.dirname(__FILE__) + '/../../spec_helper'
require 'matrix'

describe "Matrix#column_size" do
  it "returns the number of elements in the first column" do
    Matrix[ [1,2] ].column_size.should == 2
    Matrix[ [1,2,3],[1,2] ].column_size.should == 3
  end
end
