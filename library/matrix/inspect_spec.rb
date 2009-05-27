require File.dirname(__FILE__) + '/../../spec_helper'
require 'matrix'

describe "Matrix#inspect" do
  
  it "returns a String beginning with 'Matrix'" do
    i = Matrix[ [1,2], [0,1] ].inspect
    i.should be_an_instance_of(String)
    i.start_with?('Matrix').should be_true
  end

  it "returns a stringified representation of the Matrix" do
    Matrix[ [1,2], [2,1] ].inspect.should == "Matrix[[1, 2], [2, 1]]"
  end

end
