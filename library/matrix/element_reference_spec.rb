require File.dirname(__FILE__) + '/../../spec_helper'
require 'matrix'

describe "Matrix#[]" do

  before(:all) do
    @m = Matrix[[0, 1, 2], [3, 4, 5], [6, 7, 8], [9, 10, 11]]
  end

  it "returns element at (i, j)" do
    (0..3).each do |i|
      (0..2).each do |j|
        @m[i, j].should == (i * 3) + j
      end
    end
  end

  # FIXME: Update this guard when the bug is fixed.
  ruby_bug "#1518", "1.9.1.129" do
    # A NoMethodError is raised when the _first_ index is out of bounds,
    # (http://redmine.ruby-lang.org/issues/show/1518); otherwise nil is
    # returned.
    it "returns nil for an invalid index pair" do
      @m[8,1].should be_nil
      @m[1,8].should be_nil
    end
  end
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

describe "Matrix.[] with a non-Array" do
  it "tries to calls .to_ary on argument" do
    thing = mock('ary').should_receive(:to_ary).and_return(Array.new)
    Matrix[ thing ]
  end
  
  it "creates a single-element Matrix from a numeric argument" do
    Matrix[42].should == Matrix[[42]]
  end  
end
