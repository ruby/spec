require File.dirname(__FILE__) + '/../../spec_helper'
require 'matrix'

describe "Matrix#minor" do
  before(:each) do
    @matrix = Matrix[ [1,2], [3,4], [5,6] ]
  end  

  describe "with start_row, nrows, start_col, ncols" do
    it "returns the given portion of the Matrix" do
      @matrix.minor(0,1,0,2).should == Matrix[ [1, 2] ]
      @matrix.minor(1,2,1,1).should == Matrix[ [4], [6] ]
    end
 
    it "returns an empty Matrix unless nrows and ncols are greater than 0" do
      @matrix.minor(0,0,0,0).should == Matrix[]
      @matrix.minor(1,0,1,0).should == Matrix[]
      @matrix.minor(1,0,1,1).should == Matrix.columns([])
      @matrix.minor(1,1,1,0).should == Matrix[[]]
    end

    it "returns nil for out-of-bounds start_row/col" do
      @matrix.minor(4,0,0,10).should == nil
      @matrix.minor(0,10,3,9).should == nil
    end

    it "returns empty matrices for extreme start_row/col" do
      @matrix.minor(3,10,1,10).should == Matrix.columns([[]])
      @matrix.minor(1,10,2,10).should == Matrix[[], []] 
      @matrix.minor(3,0,0,10).should == Matrix[]
    end

    it "ignores big nrows or ncols" do
      @matrix.minor(0,1,0,20).should == Matrix[ [1, 2] ]
      @matrix.minor(1,20,1,1).should == Matrix[ [4], [6] ]
    end
  end
   
  describe "with col_range, row_range" do
    it "returns the given portion of the Matrix" do
      @matrix.minor(0..0, 0..1).should == Matrix[ [1, 2] ]
      @matrix.minor(1..2, 1..2).should == Matrix[ [4], [6] ]
      @matrix.minor(1...3, 1...3).should == Matrix[ [4], [6] ]
    end
 
    it "returns an empty Matrix if col_range or row_range don't select any elements" do
      @matrix.minor(3..6, 3..6).should == nil
    end

  end
end