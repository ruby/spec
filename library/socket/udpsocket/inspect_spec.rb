require_relative '../spec_helper'

describe 'UDPSocket#inspect' do
  before do
    @socket = UDPSocket.new

    @socket.bind('127.0.0.1', 0)
  end

  after do
    @socket.close
  end

  it 'returns a String' do
    @socket.inspect.should == "#<UDPSocket:fd #{@socket.fileno}>"
  end
end
