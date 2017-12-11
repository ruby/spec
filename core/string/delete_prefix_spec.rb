require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is "2.5" do
  describe "String#delete_prefix" do
    it "returns a new string with a given string removed from the beginning" do
      s = "chunky bacon"
      s.delete_prefix("chunky").should == " bacon"
      s.should == "chunky bacon"

      s.delete_prefix("bacon").should == "chunky bacon"
    end
  end
end

ruby_version_is "2.5" do
  describe "String#delete_prefix!" do
    it "modifies self in place and returns self" do
      s = "chunky bacon"
      s.delete_prefix!("chunky").should equal(s)
      s.should == " bacon"
    end

    it "returns nil if no modifications were made" do
      s = "chunky bacon"
      s.delete_prefix!("bacon").should == nil
      s.should == "chunky bacon"
    end

    it "raises a RuntimeError when self is frozen" do
      s = "chunky bacon".freeze

      lambda { s.delete_prefix!("chunky") }.should raise_error(RuntimeError)
      lambda { s.delete_prefix!("bacon")  }.should raise_error(RuntimeError)
    end
  end
end
