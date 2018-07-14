require_relative '../../spec_helper'

describe 'Socket::AncillaryData#family' do
  it 'returns the family as a Fixnum' do
    Socket::AncillaryData.new(:INET, :SOCKET, :RIGHTS, '').family.should == Socket::AF_INET
  end
end
