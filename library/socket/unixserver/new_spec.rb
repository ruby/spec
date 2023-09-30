require_relative '../spec_helper'
require_relative 'shared/new'

with_feature :unix_socket do
  describe "UNIXServer.new" do
    it_behaves_like :unixserver_new, :new
  end
end
