require_relative '../spec_helper'
require_relative '../fixtures/classes'

def each_basic_socket_type
  describe 'using TCPSocket' do
    before do
      @s = TCPServer.new('127.0.0.1', 0)
      @a = TCPSocket.new('127.0.0.1', @s.addr[1])
      @b = @s.accept
    end
    after do
      [@b, @a, @s].each(&:close)
    end

    it 'uses AF_INET as the address family' do
      @ra.afamily.should == Socket::AF_INET
    end

    it 'uses PF_INET as the protocol family' do
      @ra.pfamily.should == Socket::PF_INET
    end

    it 'uses SOCK_STREAM as the socket type' do
      @ra.socktype.should == Socket::SOCK_STREAM
    end

    it 'uses the correct IP address' do
      @ra.ip_address.should == '127.0.0.1'
    end

    it 'uses the correct port' do
      @ra.ip_port.should == @s.addr[1]
    end

    it 'equals local_address of peer socket' do
      @ra.to_s.should == @b.local_address.to_s
    end

    yield
  end

  guard -> { SocketSpecs.ipv6_available? } do
    describe 'using IPv6' do
      before do
        @s = TCPServer.new('::1', 0)
        @a = TCPSocket.new('::1', @s.addr[1])
        @b = @s.accept
      end
      after do
        [@b, @a, @s].each(&:close)
      end

      it 'uses AF_INET6 as the address family' do
        @ra.afamily.should == Socket::AF_INET6
      end

      it 'uses PF_INET6 as the protocol family' do
        @ra.pfamily.should == Socket::PF_INET6
      end

      it 'uses SOCK_STREAM as the socket type' do
        @ra.socktype.should == Socket::SOCK_STREAM
      end

      it 'uses the correct IP address' do
        @ra.ip_address.should == '::1'
      end

      it 'uses the correct port' do
        @ra.ip_port.should == @s.addr[1]
      end

      it 'equals local_address of peer socket' do
        @ra.to_s.should == @b.local_address.to_s
      end

      yield
    end
  end

  with_feature :unix_socket do
    describe 'using UNIXSocket' do
      before do
        @path   = SocketSpecs.socket_path
        @s = UNIXServer.new(@path)
        @a = UNIXSocket.new(@path)
        @b = @s.accept
      end
      after do
        [@b, @a, @s].each(&:close)
        rm_r(@path)
      end

      it 'uses AF_UNIX as the address family' do
        @ra.afamily.should == Socket::AF_UNIX
      end

      it 'uses PF_UNIX as the protocol family' do
        @ra.pfamily.should == Socket::PF_UNIX
      end

      it 'uses SOCK_STREAM as the socket type' do
        @ra.socktype.should == Socket::SOCK_STREAM
      end

      it 'uses the correct socket path' do
        @ra.unix_path.should == @path
      end

      it 'equals local_address of peer socket' do
        @ra.to_s.should == @b.local_address.to_s
      end

      yield
    end
  end

  describe 'using UDPSocket' do
    before do
      @s = UDPSocket.new
      @s.bind("127.0.0.1", 0)
      @a = UDPSocket.new
      @a.connect("127.0.0.1", @s.addr[1])
    end
    after do
      [@a, @s].each(&:close)
    end

    it 'uses the correct address family' do
      @ra.afamily.should == Socket::AF_INET
    end

    it 'uses the correct protocol family' do
      @ra.pfamily.should == Socket::PF_INET
    end

    it 'uses SOCK_DGRAM as the socket type' do
      @ra.socktype.should == Socket::SOCK_DGRAM
    end

    it 'uses the correct IP address' do
      @ra.ip_address.should == '127.0.0.1'
    end

    it 'uses the correct port' do
      @ra.ip_port.should == @s.addr[1]
    end

    yield
  end
end

describe 'BasicSocket#remote_address' do
  each_basic_socket_type do

    before do
      @a2 = BasicSocket.for_fd(@a.fileno)
      @a2.autoclose = false
      @ra = @a2.remote_address
    end

    it 'returns an Addrinfo' do
      @ra.should be_an_instance_of(Addrinfo)
    end

    it 'can be used to connect to the server' do
      b = @ra.connect
      b.remote_address.to_s.should == @ra.to_s
      b.close
    end

    it 'uses 0 as the protocol' do
      @ra.protocol.should == 0
    end
  end
end
