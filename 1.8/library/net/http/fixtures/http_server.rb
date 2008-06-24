require 'webrick'
require 'webrick/httpservlet/abstract'

module NetHTTPSpecs
 class NullWriter
    def <<(s) end
    def puts(*args) end
    def print(*args) end
    def printf(*args) end
  end
  
  class << self
    def start_server
      server_config = {
        :BindAddress => "0.0.0.0",
        :Port => 3333,
        :Logger => WEBrick::Log.new(NullWriter.new),
        :AccessLog => [],
        :ShutdownSocketWithoutClose => true,
        :ServerType => Thread }
      
      @server = WEBrick::HTTPServer.new(server_config)
      @server.mount_proc('/') do |req, res|
        res.content_type = "text/plain"
        res.body = "This is the index page."
      end
      @server.mount_proc("/form") do |req, res|
        res.content_type = "text/plain"
        res.body = req.body
      end
      @server.start
    end
    
    def stop_server
      @server.shutdown
      sleep 0.1 until @server.status == :Stop
    end
  end
end