require File.dirname(__FILE__) + '/../../spec_helper'
require 'matrix'

describe "Matrix.[]" do
   # FIXME: Decide whether objects that can be coerced into Arrays are OK
#  it "accepts only arrays as parameters" do
#    lambda { Matrix[5] }.should raise_error(TypeError)
#    lambda { Matrix[nil] }.should raise_error(TypeError)
#    lambda { Matrix[1..2] }.should raise_error(TypeError)
#    lambda { Matrix[[1, 2], 3] }.should raise_error(TypeError)
#  end
end

describe "Matrix.[] without arguments" do
  it "creates an empty Matrix" do
    Matrix[].should == Matrix[[]]
    Matrix[].column_size.should == 0
    Matrix[].row_size.should == 0
  end
end  

describe "Matrix.[] with Arrays" do
  it "raises for non-rectangular matrices" do
    lambda{ Matrix[ [0], [0,1] ] }.should 
      raise_error(ExceptionForMatrix::ErrDimensionMismatch)
    lambda{ Matrix[ [0,1], [0,1,2], [0,1] ]}.should
      raise_error(ExceptionForMatrix::ErrDimensionMismatch)
  end

  it "returns a Matrix object" do
    Matrix[ [1] ].should be_an_instance_of(Matrix)
  end
  
  it "accepts an empty row" do
    Matrix[[]].should be_an_instance_of(Matrix)
  end

  it "can create an nxn Matrix" do  
    m = Matrix[ [20,30], [40.5, 9] ]
    m.row_size.should == 2
    m.column_size.should == 2
    m.column(0).should == Vector[20, 40.5]
    m.column(1).should == Vector[30, 9]
    m.row(0).should == Vector[20, 30]
    m.row(1).should == Vector[40.5, 9]
  end

  it "can create a nx0 Matrix" do
    m = Matrix[ [0], [1], [2] ]
    m.row_size.should == 3
    m.column_size.should == 1
    m.column(0).should == Vector[0, 1, 2]
  end

  it "can create a 0xn Matrix" do
    m = Matrix[ [0, 1, 2] ]
    m.row_size.should == 1
    m.column_size.should == 3
    m.row(0).should == Vector[0, 1, 2]
  end

end  

describe "Matrix.[] with Vectors" do
  it "accepts vector arguments" do
    a = Matrix[Vector[1, 2], Vector[3, 4]]
    a.should be_an_instance_of(Matrix)
    a.should == Matrix[ [1, 2], [3, 4] ]
  end
end

describe "Matrix.[] with a non-Array" do
  it "tries to calls .to_ary on argument" do
    thing = mock('ary').should_receive(:to_ary).and_return(Array.new)
    Matrix[ thing ]
  end
  
  it "creates a single-element Matrix from a numeric argument" do
    Matrix[42].should == Matrix[[42]]
  end  
end
