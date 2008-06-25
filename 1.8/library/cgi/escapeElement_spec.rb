require File.dirname(__FILE__) + '/../../spec_helper'
require 'cgi'

describe "CGI.escapeElement when passed String, elements, ..." do
  it "escapes only the tags of the passed elements in the passed String" do
    res = CGI.escapeElement('<BR><A HREF="url"></A>', "A", "IMG")
    res.should == "<BR>&lt;A HREF=&quot;url&quot;&gt;&lt;/A&gt"
    
    res = CGI.escapeElement('<BR><A HREF="url"></A>', ["A", "IMG"])
    res.should == "<BR>&lt;A HREF=&quot;url&quot;&gt;&lt;/A&gt"
  end
end
