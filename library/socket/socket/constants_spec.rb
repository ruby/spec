require_relative '../spec_helper'

describe 'Socket::Constants' do
  it 'defines socket types' do
    consts = %w{SOCK_DGRAM SOCK_RAW SOCK_RDM SOCK_SEQPACKET SOCK_STREAM}

    consts.each do |c|
      Socket::Constants.should have_constant(c)
    end
  end

  it 'defines protocol families' do
    consts = %w{PF_INET6 PF_INET PF_IPX PF_UNIX PF_UNSPEC}

    consts.each do |c|
      Socket::Constants.should have_constant(c)
    end
  end

  it 'defines address families' do
    consts = %w{AF_INET6 AF_INET AF_IPX AF_UNIX AF_UNSPEC}

    consts.each do |c|
      Socket::Constants.should have_constant(c)
    end
  end

  it 'defines send/receive options' do
    consts = %w{MSG_DONTROUTE MSG_OOB MSG_PEEK}

    consts.each do |c|
      Socket::Constants.should have_constant(c)
    end
  end

  it 'defines socket level options' do
    Socket::Constants.should have_constant('SOL_SOCKET')
  end

  it 'defines socket options' do
    consts = %w{SO_BROADCAST SO_DEBUG SO_DONTROUTE SO_ERROR SO_KEEPALIVE
                SO_LINGER SO_OOBINLINE SO_RCVBUF SO_REUSEADDR SO_SNDBUF SO_TYPE}

    consts.each do |c|
      Socket::Constants.should have_constant(c)
    end
  end

  it 'defines multicast options' do
    consts = %w{IP_ADD_MEMBERSHIP IP_DEFAULT_MULTICAST_LOOP
                IP_DEFAULT_MULTICAST_TTL IP_MAX_MEMBERSHIPS IP_MULTICAST_LOOP
                IP_MULTICAST_TTL}

    consts.each do |c|
      Socket::Constants.should have_constant(c)
    end
  end

  it 'defines TCP options' do
    consts = %w{TCP_MAXSEG TCP_NODELAY}

    consts.each do |c|
      Socket::Constants.should have_constant(c)
    end
  end

  it 'defines SCM options' do
    Socket::Constants.should have_constant('SCM_CREDENTIALS')
  end

  it 'defines error options' do
    consts = %w{EAI_ADDRFAMILY EAI_NODATA}

    consts.each do |c|
      Socket::Constants.should have_constant(c)
    end
  end
end
