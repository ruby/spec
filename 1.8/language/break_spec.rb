require File.dirname(__FILE__) + '/../spec_helper'

describe "The break statement" do
  it "raises a LocalJumpError if used not within block or while/for loop" do
    def x; break; end
    lambda { x }.should raise_error(LocalJumpError)
  end

  it "ends block execution if used whithin block" do
    a = []
    lambda {
      a << 1
      break
      a << 2
    }.call
    a.should == [1]
  end

  it "causes block to return value passed to break" do
    lambda { break 123; 456 }.call.should == 123
  end

  it "causes block to return nil if no value passed to break" do
    lambda { break; 456 }.call.should == nil
  end
end

describe "The break statement in the method's block" do
  it "returns from that singleton method" do
    obj = Object.new
    def obj.meth_with_block
      yield
      fail("break didn't break from the singleton method")
    end
    obj.meth_with_block do
      break
    end
  end

  it "returns from the method" do
    class BreakTest
      def self.meth_with_block
        yield
        fail("break didn't break from the method")
      end
    end
    BreakTest.meth_with_block do
      break
    end
  end

  it "returns from the method, and with the specified value" do
    class BreakTest
      def self.meth_with_block
        yield
      end
    end
    res = BreakTest.meth_with_block do
      break :return_value
    end
    res.should == :return_value
  end

  # Discovered in JRuby (see JRUBY-2756)
  it "returns from the original method associated with the block even in case of chained calls" do
    class BreakTest
      def self.blocks_yielder(&b)
        yield
      end
      def self.call_yielder(&b)
        blocks_yielder(&b)
        fail("break didn't return from 'blocks_yielder' method to the proper place")
      end

      def self.blocks_caller(&b)
        b.call
      end
      def self.call_caller(&b)
        blocks_caller(&b)
        fail("break didn't return from 'blocks_caller' method to the proper place")
      end
    end

    # this calls a method that calls another method that yields to the block
    BreakTest.call_yielder do
      break
    end

    # this calls a method that calls another method that calls the block
    BreakTest.call_caller do
      break
    end

    res = BreakTest.call_yielder do
      break :return_value
    end
    res.should == :return_value

    res = BreakTest.call_caller do
      break :return_value
    end
    res.should == :return_value

  end
end

describe "Breaking out of a loop with a value" do

  it "assigns objects" do
    a = loop do break; end;          a.should == nil
    a = loop do break nil; end;      a.should == nil
    a = loop do break 1; end;        a.should == 1
    a = loop do break []; end;       a.should == []
    a = loop do break [1]; end;      a.should == [1]
    a = loop do break [nil]; end;    a.should == [nil]
    a = loop do break [[]]; end;     a.should == [[]]
    a = loop do break [*[]]; end;    a.should == []
    a = loop do break [*[1]]; end;   a.should == [1]
    a = loop do break [*[1,2]]; end; a.should == [1,2]
  end

  it "assigns splatted objects" do
    a = loop do break *nil; end;      a.should == nil
    a = loop do break *1; end;        a.should == 1
    a = loop do break *[]; end;       a.should == nil
    a = loop do break *[1]; end;      a.should == 1
    a = loop do break *[nil]; end;    a.should == nil
    a = loop do break *[[]]; end;     a.should == []
    a = loop do break *[*[]]; end;    a.should == nil
    a = loop do break *[1]; end;      a.should == 1
    a = loop do break *[*[1]]; end;   a.should == 1
    a = loop do break *[1,2]; end;    a.should == [1,2]
    a = loop do break *[*[1,2]]; end; a.should == [1,2]
  end

  it "assigns to a splatted reference" do
    *a = loop do break; end;          a.should == [nil]
    *a = loop do break nil; end;      a.should == [nil]
    *a = loop do break 1; end;        a.should == [1]
    *a = loop do break []; end;       a.should == [[]]
    *a = loop do break [1]; end;      a.should == [[1]]
    *a = loop do break [nil]; end;    a.should == [[nil]]
    *a = loop do break [[]]; end;     a.should == [[[]]]
    *a = loop do break [1,2]; end;    a.should == [[1,2]]
    *a = loop do break [*[]]; end;    a.should == [[]]
    *a = loop do break [*[1]]; end;   a.should == [[1]]
    *a = loop do break [*[1,2]]; end; a.should == [[1,2]]
  end

  it "assigns splatted objects to a splatted reference" do
    *a = loop do break *nil; end;      a.should == [nil]
    *a = loop do break *1; end;        a.should == [1]
    *a = loop do break *[]; end;       a.should == [nil]
    *a = loop do break *[1]; end;      a.should == [1]
    *a = loop do break *[nil]; end;    a.should == [nil]
    *a = loop do break *[[]]; end;     a.should == [[]]
    *a = loop do break *[1,2]; end;    a.should == [[1,2]]
    *a = loop do break *[*[]]; end;    a.should == [nil]
    *a = loop do break *[*[1]]; end;   a.should == [1]
    *a = loop do break *[*[1,2]]; end; a.should == [[1,2]]
  end

  it "assigns splatted objects to a splatted reference from a splatted loop" do
    *a = *loop do break *nil; end;      a.should == [nil]
    *a = *loop do break *1; end;        a.should == [1]
    *a = *loop do break *[]; end;       a.should == [nil]
    *a = *loop do break *[1]; end;      a.should == [1]
    *a = *loop do break *[nil]; end;    a.should == [nil]
    *a = *loop do break *[[]]; end;     a.should == []
    *a = *loop do break *[1,2]; end;    a.should == [1,2]
    *a = *loop do break *[*[]]; end;    a.should == [nil]
    *a = *loop do break *[*[1]]; end;   a.should == [1]
    *a = *loop do break *[*[1,2]]; end; a.should == [1,2]
  end

  it "assigns objects to multiple block variables" do
    a,b,*c = loop do break; end;          [a,b,c].should == [nil,nil,[]]
    a,b,*c = loop do break nil; end;      [a,b,c].should == [nil,nil,[]]
    a,b,*c = loop do break 1; end;        [a,b,c].should == [1,nil,[]]
    a,b,*c = loop do break []; end;       [a,b,c].should == [nil,nil,[]]
    a,b,*c = loop do break [1]; end;      [a,b,c].should == [1,nil,[]]
    a,b,*c = loop do break [nil]; end;    [a,b,c].should == [nil,nil,[]]
    a,b,*c = loop do break [[]]; end;     [a,b,c].should == [[],nil,[]]
    a,b,*c = loop do break [1,2]; end;    [a,b,c].should == [1,2,[]]
    a,b,*c = loop do break [*[]]; end;    [a,b,c].should == [nil,nil,[]]
    a,b,*c = loop do break [*[1]]; end;   [a,b,c].should == [1,nil,[]]
    a,b,*c = loop do break [*[1,2]]; end; [a,b,c].should == [1,2,[]]
  end

  it "assigns splatted objects to multiple block variables" do
    a,b,*c = loop do break *nil; end;      [a,b,c].should == [nil,nil,[]]
    a,b,*c = loop do break *1; end;        [a,b,c].should == [1,nil,[]]
    a,b,*c = loop do break *[]; end;       [a,b,c].should == [nil,nil,[]]
    a,b,*c = loop do break *[1]; end;      [a,b,c].should == [1,nil,[]]
    a,b,*c = loop do break *[nil]; end;    [a,b,c].should == [nil,nil,[]]
    a,b,*c = loop do break *[[]]; end;     [a,b,c].should == [nil,nil,[]]
    a,b,*c = loop do break *[1,2]; end;    [a,b,c].should == [1,2,[]]
    a,b,*c = loop do break *[*[]]; end;    [a,b,c].should == [nil,nil,[]]
    a,b,*c = loop do break *[*[1]]; end;   [a,b,c].should == [1,nil,[]]
    a,b,*c = loop do break *[*[1,2]]; end; [a,b,c].should == [1,2,[]]
  end

  it "stops any loop type at the correct spot" do
    i = 0; loop do break i if i == 2; i+=1; end.should == 2
    i = 0; loop do break if i == 3; i+=1; end; i.should == 3
    i = 0; 0.upto(5) {|i| break i if i == 2 }.should == 2
    i = 0; 0.upto(5) {|i| break if i == 3 }; i.should == 3
    i = 0; while (i < 5) do break i if i == 2 ; i+=1; end.should == 2
    i = 0; while (i < 5) do break if i == 3 ; i+=1; end; i.should == 3
  end

  it "stops a yielded method at the correct spot" do
    def break_test()
      yield 1
      yield 2
      yield 3
    end
    break_test {|i| break i if i == 2 }.should == 2
    i = 0
    break_test {|i| break i if i == 1 }
    i.should == 1
  end

end
