require_relative '../../spec_helper'

describe 'Socket::AncillaryData#level' do
  it 'returns the level as a Fixnum' do
    Socket::AncillaryData.new(:INET, :SOCKET, :RIGHTS, '').level.should == Socket::SOL_SOCKET
  end
end
