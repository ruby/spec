require File.dirname(__FILE__) + '/../../spec_helper'
require 'matrix'

describe "Matrix.columns" do
  before :each do
    @a = [1, 2]
    @b = [3, 4]
    @m = Matrix.columns([@a, @b])
  end
  
  it "creates a matrix from argument columns" do
    @m.column(0).to_a.should == @a
    @m.column(1).to_a.should == @b
  end

  it "raises an exception on an empty Matrix" do
    # Note that MRI raises NoMethodError because #size is called
    # on nil. This appears to be more of an "oops" rather than
    # an aspect of the interface. We don't spec the exception class.
    lambda{ Matrix.columns([]) }.should raise_error
  end
end
