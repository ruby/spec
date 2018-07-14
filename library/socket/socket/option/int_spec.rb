require_relative '../../spec_helper'

describe 'Socket::Option.bool' do
  it 'returns a Socket::Option' do
    opt = Socket::Option.int(:INET, :IP, :TTL, 4)

    opt.should be_an_instance_of(Socket::Option)

    opt.family.should  == Socket::AF_INET
    opt.level.should   == Socket::IPPROTO_IP
    opt.optname.should == Socket::IP_TTL
    opt.data.should    == [4].pack('i')
  end
end

describe 'Socket::Option#int' do
  it 'returns a Fixnum' do
    Socket::Option.int(:INET, :IP, :TTL, 4).int.should == 4
  end

  it 'raises TypeError when called on a non integer option' do
    opt = Socket::Option.linger(1, 4)

    lambda { opt.int }.should raise_error(TypeError)
  end
end
