require_relative '../../spec_helper'

ruby_version_is "4.0" do
  describe "CGI" do
    it "only provides the cgi/escape methods when required" do
      ruby_exe("require 'cgi/escape'; print CGI.singleton_methods.sort.inspect", options: "--disable-gems").should ==
        [:escape, :escapeElement, :escapeHTML, :escapeURIComponent,
         :escape_element, :escape_html, :escape_uri_component, :h,
         :unescape, :unescapeElement, :unescapeHTML, :unescapeURIComponent,
         :unescape_element, :unescape_html, :unescape_uri_component].inspect
    end

    it "does not define CGI::Cookie or CGI.parse" do
      ruby_exe("require 'cgi'; print [defined?(CGI::Cookie), CGI.respond_to?(:parse)].inspect", options: "--disable-gems").should ==
        [nil, false].inspect
    end
  end
end
