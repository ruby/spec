module CGISpecs
  class HtmlExtension
    def initialize
      self.extend(CGI::Html4)
      self.element_init
      self.extend(CGI::HtmlExtension)
    end
  end
end