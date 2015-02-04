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

    a.should_receive(:<=>).once.and_return(0)
    (a == b).should == true

    a = ComparableSpecs::Weird.new(0)
    a.should_receive(:<=>).once.and_return(0.0)
    (a == b).should == true
  end

  it "returns false if calling #<=> on self returns a non-zero Integer" do
    a = ComparableSpecs::Weird.new(0)
    b = ComparableSpecs::Weird.new(10)

    a.should_receive(:<=>).once.and_return(1)
    (a == b).should == false

    a = ComparableSpecs::Weird.new(0)
    a.should_receive(:<=>).once.and_return(-1)
    (a == b).should == false
  end

  context "when #<=> returns nil" do
    ruby_version_is ""..."1.9" do
      it "returns nil" do
        a = ComparableSpecs::Weird.new(0)
        b = ComparableSpecs::Weird.new(10)

        a.should_receive(:<=>).once.and_return(nil)
        (a == b).should == nil
      end
    end

    ruby_version_is "1.9" do
      it "returns false" do
        a = ComparableSpecs::Weird.new(0)
        b = ComparableSpecs::Weird.new(10)

        a.should_receive(:<=>).once.and_return(nil)
        (a == b).should be_false
      end
    end
  end

  context "when #<=> returns nor nil neither an Integer" do
    ruby_version_is ""..."1.9" do
      it "returns nil" do
        a = ComparableSpecs::Weird.new(0)
        b = ComparableSpecs::Weird.new(10)

        a.should_receive(:<=>).once.and_return("abc")
        (a == b).should == nil
      end
    end

    ruby_version_is "1.9"..."2.3" do
      it "returns false" do
        a = ComparableSpecs::Weird.new(0)
        b = ComparableSpecs::Weird.new(10)

        a.should_receive(:<=>).once.and_return("abc")
        (a == b).should be_false
      end
    end

    ruby_version_is "2.3" do
      it "raises an ArgumentError" do
        a = ComparableSpecs::Weird.new(0)
        b = ComparableSpecs::Weird.new(10)

        a.should_receive(:<=>).once.and_return("abc")
        lambda { a == b }.should raise_error(ArgumentError)
      end
    end
  end

  context "when #<=> raises an exception" do
    it "lets it go through if it is not a StandardError" do
      a = ComparableSpecs::Weird.new(0)
      b = ComparableSpecs::Weird.new(10)

      def a.<=>(b) raise Exception, "test"; end
      lambda { a == b }.should raise_error(Exception)
    end

    ruby_version_is ""..."1.9" do
      it "returns nil if it is a StandardError" do
        a = ComparableSpecs::Weird.new(0)
        b = ComparableSpecs::Weird.new(10)

        def a.<=>(b) raise StandardError, "test"; end
        (a == b).should == nil

        # TypeError < StandardError
        def a.<=>(b) raise TypeError, "test"; end
        (a == b).should == nil
      end
    end

    ruby_version_is "1.9"..."2.3" do
      # Behaviour confirmed by MRI test suite
      it "returns false if it is a StandardError" do
        a = ComparableSpecs::Weird.new(0)
        b = ComparableSpecs::Weird.new(10)

        def a.<=>(b) raise StandardError, "test"; end
        (a == b).should be_false

        def a.<=>(b) raise TypeError, "test"; end
        (a == b).should be_false
      end
    end

    ruby_version_is "2.3" do
      # Behaviour confirmed by MRI test suite
      it "lets it go through if it is a StandardError" do
        a = ComparableSpecs::Weird.new(0)
        b = ComparableSpecs::Weird.new(10)

        def a.<=>(b) raise StandardError, "test"; end
        lambda { (a == b).should be_false }.should raise_error(StandardError)

        def a.<=>(b) raise TypeError, "test"; end
        lambda { (a == b).should be_false }.should raise_error(TypeError)

        def a.<=>(b) raise Exception, "test"; end
        lambda { (a == b).should be_false }.should raise_error(Exception)
      end
    end
  end
end
