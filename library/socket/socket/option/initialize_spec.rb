# Copyright (c) 2013, Brian Shirai
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
# 3. Neither the name of the library nor the names of its contributors may be
#    used to endorse or promote products derived from this software without
#    specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
# OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
# EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

require File.expand_path('../../../../../spec_helper', __FILE__)
require File.expand_path('../../../fixtures/classes', __FILE__)

require 'socket'

describe 'Socket::Option#initialize' do
  before do
    @bool = [0].pack('i')
  end

  describe 'using Fixnums' do
    it 'returns a Socket::Option' do
      opt = Socket::Option
        .new(Socket::AF_INET, Socket::SOL_SOCKET, Socket::SO_KEEPALIVE, @bool)

      opt.should be_an_instance_of(Socket::Option)

      opt.family.should  == Socket::AF_INET
      opt.level.should   == Socket::SOL_SOCKET
      opt.optname.should == Socket::SO_KEEPALIVE
      opt.data.should    == @bool
    end
  end

  describe 'using Symbols' do
    it 'returns a Socket::Option' do
      opt = Socket::Option.new(:INET, :SOCKET, :KEEPALIVE, @bool)

      opt.should be_an_instance_of(Socket::Option)

      opt.family.should  == Socket::AF_INET
      opt.level.should   == Socket::SOL_SOCKET
      opt.optname.should == Socket::SO_KEEPALIVE
      opt.data.should    == @bool
    end

    it 'raises when using an invalid address family' do
      proc { Socket::Option.new(:INET2, :SOCKET, :KEEPALIVE, @bool) }
        .should raise_error(SocketError)
    end

    it 'raises when using an invalid level' do
      proc { Socket::Option.new(:INET, :CATS, :KEEPALIVE, @bool) }
        .should raise_error(SocketError)
    end

    it 'raises when using an invalid option name' do
      proc { Socket::Option.new(:INET, :SOCKET, :CATS, @bool) }
        .should raise_error(SocketError)
    end
  end

  describe 'using Strings' do
    it 'returns a Socket::Option' do
      opt = Socket::Option.new('INET', 'SOCKET', 'KEEPALIVE', @bool)

      opt.should be_an_instance_of(Socket::Option)

      opt.family.should  == Socket::AF_INET
      opt.level.should   == Socket::SOL_SOCKET
      opt.optname.should == Socket::SO_KEEPALIVE
      opt.data.should    == @bool
    end

    it 'raises when using an invalid address family' do
      proc { Socket::Option.new('INET2', 'SOCKET', 'KEEPALIVE', @bool) }
        .should raise_error(SocketError)
    end

    it 'raises when using an invalid level' do
      proc { Socket::Option.new('INET', 'CATS', 'KEEPALIVE', @bool) }
        .should raise_error(SocketError)
    end

    it 'raises when using an invalid option name' do
      proc { Socket::Option.new('INET', 'SOCKET', 'CATS', @bool) }
        .should raise_error(SocketError)
    end
  end
end
