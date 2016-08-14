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

describe 'Socket::Option.bool' do
  it 'returns a Socket::Option' do
    opt = Socket::Option.bool(:INET, :SOCKET, :KEEPALIVE, true)

    opt.should be_an_instance_of(Socket::Option)

    opt.family.should  == Socket::AF_INET
    opt.level.should   == Socket::SOL_SOCKET
    opt.optname.should == Socket::SO_KEEPALIVE
    opt.data.should    == [1].pack('i')
  end
end

describe 'Socket::Option#bool' do
  it 'returns a boolean' do
    Socket::Option.bool(:INET, :SOCKET, :KEEPALIVE, true).bool.should  == true
    Socket::Option.bool(:INET, :SOCKET, :KEEPALIVE, false).bool.should == false
  end

  it 'raises TypeError when called on a non boolean option' do
    opt = Socket::Option.linger(1, 4)

    proc { opt.bool }.should raise_error(TypeError)
  end
end
