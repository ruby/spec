module NetHTTPHeaderSpecs
  class Example
    include Net::HTTPHeader
    
    def initialize
      initialize_http_header({})
    end
  end
end