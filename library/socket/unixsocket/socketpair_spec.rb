require_relative '../spec_helper'
require_relative '../fixtures/classes'
require_relative '../shared/partially_closable_sockets'

with_feature :unix_socket do
  describe "UNIXSocket.socketpair" do
    it_should_behave_like :partially_closable_sockets

    before :each do
      @s1, @s2 = UNIXSocket.socketpair
    end

    after :each do
      @s1.close
      @s2.close
    end

    it "returns two UNIXSockets" do
      @s1.should be_an_instance_of(UNIXSocket)
      @s2.should be_an_instance_of(UNIXSocket)
    end

    it "returns a pair of connected sockets" do
      @s1.puts "foo"
      @s2.gets.should == "foo\n"
    end

    it "sets the socket paths to empty Strings" do
      @s1.path.should == ""
      @s2.path.should == ""
    end

    it "sets the socket addresses to empty Strings" do
      @s1.addr.should == ["AF_UNIX", ""]
      @s2.addr.should == ["AF_UNIX", ""]
    end

    it "sets the socket peer addresses to empty Strings" do
      @s1.peeraddr.should == ["AF_UNIX", ""]
      @s2.peeraddr.should == ["AF_UNIX", ""]
    end
  end
end
