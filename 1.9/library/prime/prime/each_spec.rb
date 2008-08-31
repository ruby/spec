require File.dirname(__FILE__) + '/../../../spec_helper'
require 'timeout'
require 'stringio'
load 'prime.rb'    # force reload. mspec seems to remove some class methods from Prime

describe "Prime.each" do
  before(:all) do
    @enough_seconds = 3
    @primes = [
      2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37,
      41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83,
      89, 97
    ]
  end

  it "iterates the given block over all prime numbers" do
    enumerated = []
    Prime.each do |prime|
      break if prime >= 100
      enumerated << prime
    end
    enumerated.should == @primes
  end

  it "iterates the given block infinitely" do
    lambda {
      Timeout.timeout(@enough_seconds) {
        Prime.each {|prime| 
          (2..Math.sqrt(prime)).all?{|n| prime%n != 0 }.should be_true
        }
      }
    }.should raise_error(Timeout::Error)
  end

  it "iterates the given block over all p:prime, p < n when a positive integer n is given as an argument" do
    enumerated = []
    Prime.each(100) do |prime|
      enumerated << prime
    end
    enumerated.should == @primes
  end

  it "passes a prime to the given block ascendently" do
    prev = 1
    Prime.each(10000) do |prime|
      prime.should > prev
      prev = prime
    end
  end

  it "takes a pseudo-prime generator as the second argument" do
    generator = mock('very bad pseudo-prime generator')
    generator.should_receive(:upper_bound).and_return(100)
    generator.should_receive(:upper_bound=).at_least(:twice)
    generator.should_receive(:each).and_yield(2).and_yield(3).and_yield(4).and_yield(5).and_yield(6)

    enumerated = []
    Prime.each(100, generator) do |prime| 
      enumerated << prime
    end
    enumerated.should == [2, 3, 4, 5, 6]
  end

  it "returns an evaluated value of the given block" do
    expected = Object.new
    Prime.each(5){ expected }.should equal?(expected)
  end

  it "returns an enumerator (or compatible object) if no block given" do
    obj = Prime.each
    obj.should kind_of?(Enumerable)
    obj.should respond_to?(:with_index)
    obj.should respond_to?(:with_object)
    obj.should respond_to?(:next)
    obj.should respond_to?(:rewind)
  end

  it "returns an enumerator which remembers the given upper bound" do
    enum = Prime.each(100)
    enumerated = []
    Timeout.timeout(1) {
      enum.each do |p| 
        enumerated << p
      end
    }
    enumerated.should == @primes
  end

  it "returns an enumerator which is independent to any other enumerator" do
    enum1 = Prime.each(10)
    enum2 = Prime.each(10)

    enum1.next.should == 2
    enum1.next.should == 3
    enum1.next.should == 5
    enum2.next.should == 2
    enum1.next.should == 7
    enum2.next.should == 3
  end

  it "returns an enumerator which can be rewinded via #rewind" do
    enum = Prime.each(10)

    enum.next.should == 2
    enum.next.should == 3
    enum.rewind
    enum.next.should == 2
  end

  it "starts from 2 regardless of the prior #each" do
    Prime.each do |p|
      break p > 10
    end

    prime = nil
    Prime.each do |p|
      prime = p
      break
    end
    prime.should == 2
  end

  it "starts from 2 regardless of the prior Prime.each.next" do
    enum = Prime.each(100)
    enum.next.should == 2
    enum.next.should == 3

    prime = nil
    Prime.each do |p|
      prime = p
      break
    end
    prime.should == 2
  end
end

describe "Prime#each" do
  before(:all) do
    @enough_seconds = 3
    @primes = [
      2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37,
      41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83,
      89, 97
    ].freeze
  end

  before(:all) do
    @orig_stderr = $stderr
    $stderr = StringIO.new('', 'w') # suppress warning
  end
  after(:all) do
    $stderr = @orig_stderr
  end

  before do
    @ps = Prime.new
  end

  it "iterates the given block over all prime numbers" do
    enumerated = []
    @ps.each do |prime|
      break if prime >= 100
      enumerated << prime
    end
    enumerated.should == @primes
  end

  it "iterates the given block infinitely" do
    lambda {
      Timeout.timeout(@enough_seconds) {
        @ps.each {|prime| 
          (2..Math.sqrt(prime)).all?{|n| prime%n != 0 }.should be_true
        }
      }
    }.should raise_error(Timeout::Error)
  end

  it "iterates the given block over all p:prime, p < n when a positive integer n is given as an argument" do
    enumerated = []
    @ps.each(100) do |prime|
      enumerated << prime
    end
    enumerated.should == @primes
  end

  it "passes a prime to the given block ascendently" do
    prev = 1
    @ps.each(10000) do |prime|
      prime.should > prev
      prev = prime
    end
  end

  it "returns an evaluated value of the given block" do
    expected = Object.new
    Prime.new.each(5){ expected }.should equal?(expected)
  end

  it "returns an enumerator (or a compatible object) if no block given" do
    obj = @ps.each
    obj.should kind_of?(Enumerable)
    obj.should respond_to?(:with_index)
    obj.should respond_to?(:with_object)
    obj.should respond_to?(:next)
    obj.should respond_to?(:rewind)
  end

  it "returns an enumerator which remembers the given upper bound" do
    enum = @ps.each(100)
    enumerated = []
    Timeout.timeout(1) {
      enum.each do |p| 
        enumerated << p
      end
    }
    enumerated.should == @primes
  end


  it "does not rewind the generator, each loop start at the current value" do
    @ps.next
    result = []

    @ps.each do |p|
      result << p
      break if p > 10
    end

    result.should == [3, 5, 7, 11]

    result = []
    @ps.each do |p|
      result << p
      break if p > 20
    end

    result.should == [13, 17, 19, 23]
  end
end
