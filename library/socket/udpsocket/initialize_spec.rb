require_relative '../spec_helper'

describe 'UDPSocket#initialize' do
  it 'initializes a new UDPSocket' do
    UDPSocket.new.should be_an_instance_of(UDPSocket)
  end

  it 'initializes a new UDPSocket using a Fixnum' do
    UDPSocket.new(Socket::AF_INET).should be_an_instance_of(UDPSocket)
  end

  it 'initializes a new UDPSocket using a Symbol' do
    UDPSocket.new(:INET).should be_an_instance_of(UDPSocket)
  end

  it 'initializes a new UDPSocket using a String' do
    UDPSocket.new('INET').should be_an_instance_of(UDPSocket)
  end

  it 'sets the socket to binmode' do
    UDPSocket.new(:INET).binmode?.should be_true
  end

  it 'raises Errno::EAFNOSUPPORT when given an invalid address family' do
    lambda { UDPSocket.new(666) }.should raise_error(Errno::EAFNOSUPPORT)
  end
end
