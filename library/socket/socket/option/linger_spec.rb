require_relative '../../spec_helper'

describe 'Socket::Option.linger' do
  describe 'using a Fixnum as the first argument' do
    it 'returns a Socket::Option' do
      opt = Socket::Option.linger(1, 4)

      opt.should be_an_instance_of(Socket::Option)

      opt.family.should  == Socket::AF_UNSPEC
      opt.level.should   == Socket::SOL_SOCKET
      opt.optname.should == Socket::SO_LINGER

      opt.data.should be_an_instance_of(String)
    end
  end

  describe 'using a boolean as the first argument' do
    it 'returns a Socket::Option' do
      opt = Socket::Option.linger(true, 4)

      opt.should be_an_instance_of(Socket::Option)

      opt.family.should  == Socket::AF_UNSPEC
      opt.level.should   == Socket::SOL_SOCKET
      opt.optname.should == Socket::SO_LINGER

      opt.data.should be_an_instance_of(String)
    end
  end
end

describe 'Socket::Option#linger' do
  it 'returns an Array containing the on/off option and linger time' do
    opt = Socket::Option.linger(1, 4)

    opt.linger.should == [true, 4]
  end

  it 'raises TypeError when called on a non SOL_SOCKET/SO_LINGER option' do
    opt = Socket::Option.int(:INET, :IP, :TTL, 4)

    lambda { opt.linger }.should raise_error(TypeError)
  end

  it 'raises TypeError when called on a non linger option' do
    opt = Socket::Option.new(:INET, :SOCKET, :LINGER, '')

    lambda { opt.linger }.should raise_error(TypeError)
  end
end
