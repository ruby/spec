require File.dirname(__FILE__) + '/../../spec_helper'
require 'matrix'

describe "Matrix.[] with an Integer-like argument" do
  # Matrix.[] is really a constructor, not an element reference function...

  before(:each) do
    @number = 2
    @m = Matrix[@number]
  end
  
  it "returns an object of type Matrix" do
    @m.class.should == Matrix
  end
  
  it "coerces its argument into an Array" do
    @m.should == Matrix[[@number]]
  end

  it "creates a 1x1 Matrix" do  
    @m.row_size.should == 1
    @m.column_size.should == 1
  end

  it "sets the 0th column in the 0th row to the argument" do
    @m[0,0].should == @number
  end  
end

describe "Matrix.[] with a Float-like argument" do
  # Matrix.[] is really a constructor, not an element reference function...

  before(:each) do
    @number = 2.5
    @m = Matrix[@number]
  end
  
  it "returns an object of type Matrix" do
    @m.class.should == Matrix
  end
  
  it "coerces its argument into an Array" do
    @m.should == Matrix[[@number]]
  end

  it "creates a 1x1 Matrix" do  
    @m.row_size.should == 1
    @m.column_size.should == 1
  end

  it "sets the 0th column in the 0th row to the argument" do
    @m[0,0].should == @number
  end  
end

describe "Matrix.[] with a Rational-like argument" do
  # Matrix.[] is really a constructor, not an element reference function...

  before(:each) do
    @number = Rational(4,3)
    @m = Matrix[@number]
  end
  
  it "returns an object of type Matrix" do
    @m.class.should == Matrix
  end
  
  it "coerces its argument into an Array" do
    @m.should == Matrix[[@number]]
  end

  it "creates a 1x1 Matrix" do  
    @m.row_size.should == 1
    @m.column_size.should == 1
  end

  it "sets the 0th column in the 0th row to the argument" do
    @m[0,0].should == @number
  end  
end

# TODO: Accept non-square matrices?
describe "Matrix.[] with at least one Array" do
  # Matrix.[] is really a constructor, not an element reference function...

  before(:each) do
    @a = [1,2]
    @b = [3,4]
    @m = Matrix[ @a, @b ]
  end
  
  it "returns an object of type Matrix" do
    @m.class.should == Matrix
  end
  
  it "treats each Array as a row in the Matrix" do
    @m.row_size.should == 2
    @m.row(0).should == Vector[1, 2]
    @m.row(1).should == Vector[3, 4]
  end

  it "treats each element of each Array as a column in the Matrix" do
    @m.column_size.should == 2
    @m.column(0).should == Vector[1, 3]
    @m.column(1).should == Vector[2, 4]
  end

  it "raises a TypeError unless every element of every Array is numeric" do
    lambda{ Matrix[ ['w', 1] ] }.should raise_error(TypeError)
    lambda{ Matrix[ [Object.new, 3.0], [Object.new, Object.new] ] }.should
      raise_error(TypeError)
  end   
end

describe "Matrix.[] with an invalid argument" do
  it "raises an ArgumentError unless passed Arrays of numbers, or a single number" do
    lambda{ Matrix[] }.should raise_error(ArgumentError)
    lambda{ Matrix[[]] }.should raise_error(ArgumentError)
    lambda{ Matrix[ "foo" ] }.should raise_error(ArgumentError)
    lambda{ Matrix[ Hash.new ]}.should raise_error(ArgumentError)
  end  
end

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
