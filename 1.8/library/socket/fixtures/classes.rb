require 'socket'

module SocketSpecs
  Hostname = Socket.getaddrinfo("127.0.0.1", nil)[0][2]

  # helper to get the hostname associated to 127.0.0.1
  def self.hostname
    Hostname
  end

  def self.port
    40001
  end

  def self.sockaddr_in(port, host)
    Socket::SockAddr_In.new(Socket.sockaddr_in(port, host))
  end

  def self.socket_path
    "/tmp/unix_server_spec.socket"
  end
end
