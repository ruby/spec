require File.expand_path('../../../spec_helper', __FILE__)
require 'matrix'

ruby_version_is "1.9" do
  describe "Matrix#real?" do
    it "returns true for matrices with all real entries" do
      Matrix[ [1,   2], [3, 4] ].real?.should be_true
      Matrix[ [1.9, 2], [3, 4] ].real?.should be_true
    end

    it "returns true for empty matrices" do
      Matrix.empty.real?.should be_true
    end

    it "returns false if one element is a Complex" do
      Matrix[ [Complex(1,1), 2], [3, 4] ].real?.should be_false
      Matrix[ [Complex(1,0), 2], [3, 4] ].real?.should be_false
    end
  end
end