require_relative '../../../../spec_helper'

describe :random_formatter_interface, shared: true do
  it "calls the method #bytes for 4 blocks of 4 bytes" do
    bytes = mock('bytes')
    bytes.extend(Random::Formatter)
    bytes.should_receive(:bytes).with(4).exactly(4).and_return("\x00".b * 4)
    bytes.send(@method)
  end

  it "has the same output if the random byte streams are the same" do
    bytes = Object.new
    bytes.extend(Random::Formatter)
    def bytes.bytes(n)
      "\x00".b * n
    end
    bytes.send(@method).should == bytes.send(@method)
  end

  it "has different output if the random byte streams are not the same" do
    lhs = Object.new
    lhs.extend(Random::Formatter)
    def lhs.bytes(n)
      "\x00".b * n
    end
    rhs = Object.new
    rhs.extend(Random::Formatter)
    def rhs.bytes(n)
      "\x01".b * n
    end
    lhs.send(@method).should != rhs.send(@method)
  end
end
