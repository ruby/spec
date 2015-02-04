require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

no_silent_rescue = "2.3"

describe "Comparable#==" do
  a = b = nil
  before :each do
    a = ComparableSpecs::Weird.new(0)
    b = ComparableSpecs::Weird.new(10)
  end

  it "returns true if other is the same as self" do
    (a == a).should == true
    (b == b).should == true
  end

  it "calls #<=> on self with other and returns true if #<=> returns 0" do
    a.should_receive(:<=>).once.and_return(0)
    (a == b).should == true
  end

  it "calls #<=> on self with other and returns true if #<=> returns 0.0" do
    a.should_receive(:<=>).once.and_return(0.0)
    (a == b).should == true
  end

  it "returns false if calling #<=> on self returns a positive Integer" do
    a.should_receive(:<=>).once.and_return(1)
    (a == b).should == false
  end

  it "returns false if calling #<=> on self returns a negative Integer" do
    a.should_receive(:<=>).once.and_return(-1)
    (a == b).should == false
  end

  ruby_version_is ""..."1.9" do
    it "returns nil if calling #<=> on self returns nil" do
      a.should_receive(:<=>).once.and_return(nil)
      (a == b).should == nil
    end

    it "returns nil if calling #<=> on self returns a non-Integer" do
      a.should_receive(:<=>).once.and_return("abc")
      (a == b).should == nil
    end
  end

  ruby_version_is "1.9" do
    it "returns false if calling #<=> on self returns nil" do
      a.should_receive(:<=>).once.and_return(nil)
      (a == b).should be_false
    end
  end

  ruby_version_is "1.9"...no_silent_rescue do
    it "returns false if calling #<=> on self returns a non-Integer" do
      a.should_receive(:<=>).once.and_return("abc")
      (a == b).should be_false
    end
  end

  ruby_version_is no_silent_rescue do
    it "raise an ArgumentError if calling #<=> on self returns a non-Integer" do
      a.should_receive(:<=>).once.and_return("abc")
      lambda { (a == b) }.should raise_error(ArgumentError)
    end
  end

  ruby_version_is ""..."1.9" do
    it "returns nil if calling #<=> on self raises a StandardError" do
      def a.<=>(b) raise StandardError, "test"; end
      (a == b).should == nil
    end

    it "returns nil if calling #<=> on self raises a subclass of StandardError" do
      # TypeError < StandardError
      def a.<=>(b) raise TypeError, "test"; end
      (a == b).should == nil
    end
  end

  ruby_version_is "1.9"...no_silent_rescue do
    # Behaviour confirmed by MRI test suite
    it "returns false if calling #<=> on self raises a StandardError" do
      def a.<=>(b) raise StandardError, "test"; end
      (a == b).should be_false
    end

    it "returns false if calling #<=> on self raises a subclass of StandardError" do
      def a.<=>(b) raise TypeError, "test"; end
      (a == b).should be_false
    end
  end

  ruby_version_is no_silent_rescue do
    it "raises the exception if calling #<=> on self raises a StandardError" do
      def a.<=>(b) raise StandardError, "test"; end
      lambda { (a == b) }.should raise_error(StandardError)
    end

    it "raises the exception if calling #<=> on self raises a subclass of StandardError" do
      def a.<=>(b) raise TypeError, "test"; end
      lambda { (a == b) }.should raise_error(TypeError)
    end
  end

  it "raises the exception if calling #<=> on self raises an unrescued exception" do
    def a.<=>(b) raise Exception, "test"; end
    lambda { (a == b) }.should raise_error(Exception)
  end
end
