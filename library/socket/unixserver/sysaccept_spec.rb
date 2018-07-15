require_relative '../spec_helper'

with_feature :unix_socket do
  describe 'UNIXServer#sysaccept' do
    before do
      @path   = SocketSpecs.socket_path
      @server = UNIXServer.new(@path)
    end

    after do
      @server.close

      rm_r(@path)
    end

    describe 'without a client' do
      it 'blocks the calling thread' do
        lambda { @server.sysaccept }.should block_caller
      end
    end

    describe 'with a client' do
      before do
        @client = UNIXSocket.new(@path)
      end

      after do
        @client.close
      end

      describe 'without any data' do
        it 'returns a Fixnum' do
          @server.sysaccept.should be_an_instance_of(Fixnum)
        end
      end

      describe 'with data available' do
        before do
          @client.write('hello')
        end

        it 'returns a Fixnum' do
          @server.sysaccept.should be_an_instance_of(Fixnum)
        end
      end
    end
  end
end
