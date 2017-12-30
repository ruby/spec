require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

ruby_version_is "2.5" do
  describe "Integer#pow" do
    it "returns self raised to the given power" do
      2.pow(0).should eql 1
      2.pow(1).should eql 2
      2.pow(2).should eql 4

      9.pow(0.5).should eql 3.0
      9.pow(Rational(1, 2)).should eql 3.0
      5.pow(-1).to_f.to_s.should == '0.2'

      2.pow(40).should eql 1099511627776
    end

    it "overflows the answer to a bignum transparently" do
      2.pow(29).should eql 536870912
      2.pow(30).should eql 1073741824
      2.pow(31).should eql 2147483648
      2.pow(32).should eql 4294967296

      2.pow(61).should eql 2305843009213693952
      2.pow(62).should eql 4611686018427387904
      2.pow(63).should eql 9223372036854775808
      2.pow(64).should eql 18446744073709551616
      8.pow(23).should eql 590295810358705651712
    end

    it "raises negative numbers to the given power" do
      (-2).pow(29).should eql(-536870912)
      (-2).pow(30).should eql(1073741824)
      (-2).pow(31).should eql(-2147483648)
      (-2).pow(32).should eql(4294967296)

      (-2).pow(61).should eql(-2305843009213693952)
      (-2).pow(62).should eql(4611686018427387904)
      (-2).pow(63).should eql(-9223372036854775808)
      (-2).pow(64).should eql(18446744073709551616)
    end

    it "can raise 1 to a bignum safely" do
      1.pow(4611686018427387904).should eql 1
    end

    it "can raise -1 to a bignum safely" do
      (-1).pow(4611686018427387904).should eql(1)
      (-1).pow(4611686018427387905).should eql(-1)
    end

    it "returns Float::INFINITY when the number is too big" do
      2.pow(27387904).class.should == Integer
      2.pow(427387904).class.should == Float
      2.pow(427387904).should == Float::INFINITY
    end

    it "raises a ZeroDivisionError for 0 ** -1" do
      -> { 0.pow(-1) }.should raise_error(ZeroDivisionError)
      -> { 0.pow(Rational(-1, 1)) }.should raise_error(ZeroDivisionError)
    end

    it "returns Float::INFINITY for 0 ** -1.0" do
      0.pow(-1.0).should == Float::INFINITY
    end

    it "raises a TypeError when given a non-numeric power" do
      -> { 13.pow("10") }.should raise_error(TypeError)
      -> { 13.pow(:symbol) }.should raise_error(TypeError)
      -> { 13.pow(nil) }.should raise_error(TypeError)
    end

    it "coerces power and calls #**" do
      num_2 = mock("2")
      num_13 = mock("13")
      num_2.should_receive(:coerce).with(13).and_return([num_13, num_2])
      num_13.should_receive(:**).with(num_2).and_return(169)

      13.pow(num_2).should == 169
    end

    it "returns Float when power is Float" do
      2.pow(2.0).should == 4.0
    end

    it "returns Rational when power is Rational" do
      2.pow(Rational(2, 1)).should == Rational(4, 1)
    end

    it "returns a complex number when negative and raised to a fractional power" do
      (-8).pow(1.0/3)         .should be_close(Complex(1, 1.73205), TOLERANCE)
      (-8).pow(Rational(1, 3)).should be_close(Complex(1, 1.73205), TOLERANCE)
    end

    context "second argument is passed" do
      it "returns modulo of self raised to the given power" do
        2.pow(5, 12).should == 8
        2.pow(6, 13).should == 12
        2.pow(7, 14).should == 2
        2.pow(8, 15).should == 1
      end

      ruby_bug '#13669', '2.5'...'2.5.1' do
        it "works well with bignums" do
          2.pow(61, 5843009213693951).should eql 3697379018277258
          2.pow(62, 5843009213693952).should eql 1551748822859776
          2.pow(63, 5843009213693953).should eql 3103497645717974
          2.pow(64, 5843009213693954).should eql  363986077738838
        end
      end

      it "handles sign like #divmod does" do
         2.pow(5,  12).should ==  8
         2.pow(5, -12).should == -4
        -2.pow(5,  12).should ==  4
        -2.pow(5, -12).should == -8
      end

      it "ensures all arguments are integers" do
        -> { 2.pow(5, 12.0) }.should raise_error(TypeError, /2nd argument not allowed unless all arguments are integers/)
        -> { 2.pow(5, Rational(12, 1)) }.should raise_error(TypeError, /2nd argument not allowed unless all arguments are integers/)
      end

      it "raises TypeError for non-numeric value" do
        -> { 2.pow(5, "12") }.should raise_error(TypeError)
        -> { 2.pow(5, []) }.should raise_error(TypeError)
        -> { 2.pow(5, nil) }.should raise_error(TypeError)
      end

      it "raises a ZeroDivisionError when the given argument is 0" do
        -> { 2.pow(5, 0) }.should raise_error(ZeroDivisionError)
      end
    end
  end
end
