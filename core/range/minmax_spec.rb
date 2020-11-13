require_relative '../../spec_helper'

describe 'Range#minmax' do
  before(:each) do
    @x = mock('x')
    @y = mock('y')

    @x.should_receive(:<=>).with(@y).any_number_of_times.and_return(-1) # x < y
    @x.should_receive(:<=>).with(@x).any_number_of_times.and_return(0) # x == x
    @y.should_receive(:<=>).with(@x).any_number_of_times.and_return(1) # y > x
    @y.should_receive(:<=>).with(@y).any_number_of_times.and_return(0) # y == y
  end

  describe 'on an inclusive range' do
    ruby_version_is '2.6'...'2.7' do
      # Endless ranges introduced in 2.6
      it 'should try to iterate endlessly on an endless range' do
        @x.should_receive(:succ).once.and_return(@y)

        # Endless range literal would cause SyntaxError prior to 2.6
        range = Range.new(@x, nil)

        -> { range.minmax }.should raise_error(NoMethodError, /^undefined method `succ' for/)
      end
    end

    ruby_version_is '2.7' do
      it 'should raise RangeError on an endless range without iterating the range' do
        @x.should_not_receive(:succ)

        # Endless range literal would cause SyntaxError prior to 2.6
        range = Range.new(@x, nil)

        -> { range.minmax }.should raise_error(RangeError, 'cannot get the maximum of endless range')
      end
    end

    ruby_version_is '2.7'...'3.0' do
      it 'raises ArgumentError on a beginless range' do
        # Beginless range literal would cause SyntaxError prior to 2.7
        range = Range.new(nil, @x)

        -> { range.minmax }.should raise_error(ArgumentError)
      end
    end

    ruby_version_is '3.0' do
      it 'should raise RangeError on a beginless range' do
        # Beginless range literal would cause SyntaxError prior to 2.7
        range = Range.new(nil, @x)

        -> { range.minmax }.should raise_error(RangeError, 'cannot get the minimum of beginless range')
      end
    end

    it 'should return begining of range if beginning and end are equal without iterating the range' do
      @x.should_not_receive(:succ)

      (@x..@x).minmax.should == [@x, @x]
    end

    it 'should return nil pair if beginning is greater than end without iterating the range' do
      @y.should_not_receive(:succ)

      (@y..@x).minmax.should == [nil, nil]
    end

    ruby_version_is ''...'2.7' do
      it 'should return the minimum and maximum values for a non-numeric range by iterating the range' do
        @x.should_receive(:succ).once.and_return(@y)

        (@x..@y).minmax.should == [@x, @y]
      end
    end

    ruby_version_is '2.7' do
      it 'should return the minimum and maximum values for a non-numeric range without iterating the range' do
        @x.should_not_receive(:succ)

        (@x..@y).minmax.should == [@x, @y]
      end
    end

    it 'should return the minimum and maximum values for a numeric range' do
      (1..3).minmax.should == [1, 3]
    end

    ruby_version_is '2.7' do
      it 'should return the minimum and maximum values for a numeric range without iterating the range' do
        # We cannot set expectations on integers,
        # so we "prevent" iteration by picking a value that would iterate until the spec times out.
        range_end = Float::INFINITY

        (1..range_end).minmax.should == [1, range_end]
      end
    end

    it 'should return the minimum and maximum values according to the provided block by iterating the range' do
      @x.should_receive(:succ).once.and_return(@y)

      (@x..@y).minmax { |x, y| - (x <=> y) }.should == [@y, @x]
    end
  end

  describe 'on an exclusive range' do
    ruby_version_is '2.6'...'2.7' do
      # Endless ranges introduced in 2.6
      it 'should try to iterate endlessly on an endless range' do
        @x.should_receive(:succ).once.and_return(@y)

        # Endless range literal would cause SyntaxError prior to 2.6
        range = Range.new(@x, nil, true)

        -> { range.minmax }.should raise_error(NoMethodError, /^undefined method `succ' for/)
      end
    end

    ruby_version_is '2.7' do
      it 'should raise RangeError on an endless range' do
        @x.should_not_receive(:succ)

        # Endless range literal would cause SyntaxError prior to 2.6
        range = Range.new(@x, nil, true)

        -> { range.minmax }.should raise_error(RangeError, 'cannot get the maximum of endless range')
      end

      # Beginless ranges introduced in 2.7
      it 'should raise RangeError on a beginless range' do
        # Beginless range literal would cause SyntaxError prior to 2.7
        range = Range.new(nil, @x, true)

        -> { range.minmax }.should raise_error(RangeError,
          /cannot get the maximum of beginless range with custom comparison method|cannot get the minimum of beginless range/)
      end
    end

    ruby_bug "#17014", "2.7.0"..."2.8" do
      it 'should return nil pair if beginning and end are equal without iterating the range' do
        @x.should_not_receive(:succ)

        (@x...@x).minmax.should == [nil, nil]
      end

      it 'should return nil pair if beginning is greater than end without iterating the range' do
        @y.should_not_receive(:succ)

        (@y...@x).minmax.should == [nil, nil]
      end

      it 'should return the minimum and maximum values for a non-numeric range by iterating the range' do
        @x.should_receive(:succ).once.and_return(@y)

        (@x...@y).minmax.should == [@x, @x]
      end
    end

    it 'should return the minimum and maximum values for a numeric range' do
      (1...3).minmax.should == [1, 2]
    end

    ruby_version_is '2.7' do
      it 'should return the minimum and maximum values for a numeric range without iterating the range' do
        # We cannot set expectations on integers,
        # so we "prevent" iteration by picking a value that would iterate until the spec times out.
        # Since we cannot exclude a non Integer end value, we use a HUGE Integer.
        range_end = 123_456_789_012_345_678_901_234_567_890

        (1...range_end).minmax.should == [1, range_end - 1]
      end
    end

    it 'should return the minimum and maximum values according to the provided block by iterating the range' do
      @x.should_receive(:succ).once.and_return(@y)

      (@x...@y).minmax { |x, y| - (x <=> y) }.should == [@x, @x]
    end
  end
end
