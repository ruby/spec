require 'matrix'

describe :trace, :shared => true do
  it "returns the sum of diagonal elements in a square Matrix" do
    Matrix[[7,6], [3,9]].trace.should == 16
  end

  # Crashes with NoMethodError: undefined method `[]' for nil:NilClass
  ruby_bug "???", "1.9.1.129" do
    it "returns the sum of diagonal elements in a rectangular Matrix" do
      Matrix[[1,2,3], [4,5,6]].trace.should == 6  
    end
  end
    
  # Crashes with NoMethodError: undefined method `[]' for nil:NilClass
  ruby_bug "???", "1.9.1.129" do
    it "returns the sum of diagonal elements in a single-row Matrix" do
      Matrix[[1,2]].trace.should == 3
    end
  end

end
