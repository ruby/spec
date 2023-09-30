require_relative '../spec_helper'
require_relative 'shared/new'

with_feature :unix_socket do
  describe "UNIXSocket.new" do
    it_behaves_like :unixsocket_new, :new
  end
end
