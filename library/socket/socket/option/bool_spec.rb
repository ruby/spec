require_relative '../../spec_helper'

describe 'Socket::Option.bool' do
  it 'returns a Socket::Option' do
    opt = Socket::Option.bool(:INET, :SOCKET, :KEEPALIVE, true)

    opt.should be_an_instance_of(Socket::Option)

    opt.family.should  == Socket::AF_INET
    opt.level.should   == Socket::SOL_SOCKET
    opt.optname.should == Socket::SO_KEEPALIVE
    opt.data.should    == [1].pack('i')
  end
end

describe 'Socket::Option#bool' do
  it 'returns a boolean' do
    Socket::Option.bool(:INET, :SOCKET, :KEEPALIVE, true).bool.should  == true
    Socket::Option.bool(:INET, :SOCKET, :KEEPALIVE, false).bool.should == false
  end

  it 'raises TypeError when called on a non boolean option' do
    opt = Socket::Option.linger(1, 4)

    lambda { opt.bool }.should raise_error(TypeError)
  end
end
