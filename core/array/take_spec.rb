require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is "1.8.7" do
  describe "Array#take" do
    it "returns first n elements from an array." do
      [1, 2, 3].take(2).should == [1, 2]
    end
    
    it "returns all elements when argument is > array size" do
      [1, 2].take(99).should == [1, 2]
    end
    
    it "returns all elements when argument is < array size" do
      [1, 2].take(4).should == [1, 2]
    end
    
    it "returns an empty array when argument is zero" do
      [1].take(0).should == []
    end
    
    it "returns empty when array is empty" do
      [].take(3).should == []
    end
    
    it "raises ArgumentError when argument os negative" do
      lambda{ [1].take(-3) }.should raise_error(ArgumentError)
    end
  end
end