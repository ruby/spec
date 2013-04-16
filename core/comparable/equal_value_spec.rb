require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

describe "Comparable#==" do
  it "returns true if other is the same as self" do
    a = ComparableSpecs::Weird.new(0)
    b = ComparableSpecs::Weird.new(20)

    (a == a).should == true
    (b == b).should == true
  end

  it "calls #<=> on self with other and returns true if #<=> returns 0" do
    a = ComparableSpecs::Weird.new(0)
    b = ComparableSpecs::Weird.new(10)

    a.should_receive(:<=>).any_number_of_times.and_return(0)
    (a == b).should == true

    a = ComparableSpecs::Weird.new(0)
    a.should_receive(:<=>).any_number_of_times.and_return(0.0)
    (a == b).should == true
  end

  it "returns false if calling #<=> on self returns a non-zero Integer" do
    a = ComparableSpecs::Weird.new(0)
    b = ComparableSpecs::Weird.new(10)

    a.should_receive(:<=>).any_number_of_times.and_return(1)
    (a == b).should == false

    a = ComparableSpecs::Weird.new(0)
    a.should_receive(:<=>).any_number_of_times.and_return(-1)
    (a == b).should == false
  end

  ruby_version_is ""..."1.9" do
    it "returns nil if calling #<=> on self returns nil or a non-Integer" do
      a = ComparableSpecs::Weird.new(0)
      b = ComparableSpecs::Weird.new(10)

      a.should_receive(:<=>).any_number_of_times.and_return(nil)
      (a == b).should == nil

      a = ComparableSpecs::Weird.new(0)
      a.should_receive(:<=>).any_number_of_times.and_return("abc")
      (a == b).should == nil
    end
  end

  ruby_version_is "1.9" do
    it "returns false if calling #<=> on self returns nil or a non-Integer" do
      a = ComparableSpecs::Weird.new(0)
      b = ComparableSpecs::Weird.new(10)

      a.should_receive(:<=>).any_number_of_times.and_return(nil)
      (a == b).should be_false

      a = ComparableSpecs::Weird.new(0)
      a.should_receive(:<=>).any_number_of_times.and_return("abc")
      (a == b).should be_false
    end
  end

  ruby_version_is ""..."1.9" do
    it "returns nil if calling #<=> on self raises a StandardError" do
      a = ComparableSpecs::Weird.new(0)
      b = ComparableSpecs::Weird.new(10)

      def a.<=>(b) raise StandardError, "test"; end
      (a == b).should == nil

      # TypeError < StandardError
      def a.<=>(b) raise TypeError, "test"; end
      (a == b).should == nil
    end
  end

  ruby_version_is "1.9" do
    # Behaviour confirmed by MRI test suite
    it "returns false if calling #<=> on self raises a StandardError" do
      a = ComparableSpecs::Weird.new(0)
      b = ComparableSpecs::Weird.new(10)

      def a.<=>(b) raise StandardError, "test"; end
      (a == b).should be_false

      def a.<=>(b) raise TypeError, "test"; end
      (a == b).should be_false
    end
  end

  it "raises the error if calling #<=> on self raises an Exception excluding StandardError" do
    a = ComparableSpecs::Weird.new(0)
    b = ComparableSpecs::Weird.new(10)
    specific_error = Class.new Exception

    (class << a; self; end).class_eval do
      define_method :'<=>' do |other|
       raise specific_error, "test"
      end
    end
    lambda { a == b }.should raise_error(specific_error)
  end
end
