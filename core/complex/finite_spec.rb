require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is "2.4" do
  describe "Complex#finite?" do
    it "returns true if magnitude is finite" do
      (1+1i).finite?.should == true
    end

    it "returns false for positive infinity" do
      value = Complex(1, Float::INFINITY)
      value.finite?.should == false
    end

    it "returns false for negative infinity" do
      value = -Complex(1, Float::INFINITY)
      value.finite?.should == false
    end

    it "returns true for NaN" do
      value = Complex(Float::NAN, Float::NAN)
      value.finite?.should == true
    end
  end
end
