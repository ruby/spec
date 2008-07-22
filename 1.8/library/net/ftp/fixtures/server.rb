module NetFTPSpecs
  
  def with_connection
    @ftp.connect("localhost", 9921)
    yield
  end
  
  # @server = DummyFTP.new
  # @server.should_receive("USER anonymous\r\n").and_respond("230 OK, password not required")
  # @server.should_receive("ABOR\r").and_respond("502 test")
  # @server.serve_once
  # 
  # @ftp = Net::FTP.new
  # @ftp.connect("localhost", 9921)
  # 
  # @ftp.login
  # @ftp.abort
  # @ftp.quit
  # 
  # @server.stop
  class DummyFTP
    def initialize(port = 9921) 
      @server = TCPServer.new("localhost", port)
      @commands = []
    end
  
    def should_receive(data)
      @commands << { :receive => data }
      self
    end
  
    def and_respond(data)
      @commands.last[:respond] = data
    end
    alias_method :should_respond, :and_respond
  
    def serve_once
      @thread = Thread.new do
        @socket = @server.accept
        handle_request
        @socket.close
      end
    end
  
    def handle_request
      @peername = @socket.getpeername
      response "220 Dummy FTP Server ready!"
    
      begin
        loop do
          expected_command = @commands.shift

          command = @socket.recv(1024)
          break if command.nil?
        
          if expected_command.nil?
            if command == "QUIT\r\n"
              self.response("221 OK, bye")
              break
            end
          
            error_response("Unexpected command: #{command.inspect}")
          end
    
          if command == expected_command[:receive]
            if expected_command[:respond]
              self.response(expected_command[:respond])
            else
              error_response("Received #{command.inspect}, but don't know what to respond")
              break
            end
          else
            error_response("Expected #{expected_command[:receive].inspect}, but received #{command.inspect}")
            break
          end
        end
      rescue => e
        error_response("Exception: #{e}")
      end
    end
  
    def error_response(text)
      self.response("451 #{text}")
    end
  
    def response(text)
      @socket.puts(text)
    end
  
    def stop
      @server.close
      @thread.join
    end
  end
end