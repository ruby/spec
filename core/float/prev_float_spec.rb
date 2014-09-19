require File.expand_path('../../../spec_helper', __FILE__)

describe "Float" do
  ruby_version_is "2.2" do
    it "returns a float the smallest possible step greater than the receiver" do
      barely_negative = 0.0.prev_float
      barely_negative.should == 0.0.prev_float
      
      barely_negative.should < 0.0
      barely_negative.should > barely_negative.prev_float
      
      midpoint = barely_negative / 2
      [0.0, barely_negative].should include midpoint
    end

    it "steps directly between MAX and INFINITY" do
      Float::INFINITY.prev_float.should == Float::MAX
      (-Float::MAX).prev_float.should == -Float::INFINITY
    end

    it "steps directly between 1.0 and -EPSILON/2 + 1.0" do
      1.0.prev_float.should == -Float::EPSILON/2 + 1.0
    end

    it "steps directly between -1.0 and -EPSILON - 1.0" do
      (-1.0).prev_float.should == -Float::EPSILON - 1.0
    end

    it "reverses the effect of next_float" do
      0.0.next_float.prev_float.should == 0.0
      num = rand
      num.next_float.prev_float.should == num
    end

    it "returns NAN if NAN was the receiver" do
      Float::NAN.prev_float.nan?.should == true
    end
  end
end
