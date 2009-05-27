require File.dirname(__FILE__) + '/../../spec_helper'
require 'matrix'

describe "Matrix#inverse" do
 
  it "returns a Matrix" do
    Matrix[ [1,2], [2,1] ].inverse.should be_an_instance_of(Matrix)
  end

  it "returns the inverse of the Matrix" do
    Matrix[ 
      [1, 3, 3],     [1, 4, 3],  [1, 3, 4] 
    ].inverse.should == 
    Matrix[
      [7, -3, -3],   [-1, 1, 0], [-1, 0, 1]
    ]

    # FIXME: This example fails on 1.8.7 without 'mathn' being required.
    # Embarrassingly, it works on JRuby. Ask brixen what to do here
    Matrix[ 
      [1, 2, 3],    [0, 1, 4],     [5, 6, 0] 
    ].inverse.should == 
    Matrix[
      [-24, 18, 5], [20, -15, -4], [-5, 4, 1]
    ]
  end 

  it "raises a ErrDimensionMismatch if the Matrix is not square" do
    lambda{ Matrix[ [1,2], [1] ].inverse }.should 
      raise_error(Matrix::ErrDimensionMismatch)
  end  

end
