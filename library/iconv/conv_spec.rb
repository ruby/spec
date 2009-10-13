require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/shared/initialize_exceptions'
require 'iconv'

describe "Iconv.conv" do
  it_behaves_like :iconv_initialize_exceptions, :conv, "test"

  it "acts exactly as if opening a converter and invoking #iconv once" do
    Iconv.conv("utf-8", "iso-8859-1", "expos\xe9").should == "expos\xc3\xa9"

    stringlike = mock("string-like")
    stringlike.should_receive(:to_str).and_return("cacha\xc3\xa7a")
    Iconv.conv("iso-8859-1", "utf-8", stringlike).should == "cacha\xe7a"

    Iconv.conv("utf-16", "us-ascii", "a").should equal_utf16("\xfe\xff\0a")
    # each call is completely independent; never retain context!
    Iconv.conv("utf-16", "us-ascii", "b").should equal_utf16("\xfe\xff\0b")

    Iconv.conv("us-ascii", "iso-8859-1", nil).should == ""

    Iconv.conv("utf-16", "utf-8", "").should == ""

    lambda { Iconv.conv("us-ascii", "us-ascii", "test\xa9") }.should raise_error(Iconv::IllegalSequence)

    lambda { Iconv.conv("utf-8", "utf-8", "euro \xe2") }.should raise_error(Iconv::InvalidCharacter)
  end

  it "ignores invalid characters if encoding parameters contain the flag //IGNORE" do
    Iconv.conv("utf-8//IGNORE", "utf-8", "\xa4").should == ""
  end

  it "ignores undefined characters if encoding parameters contain the flag //IGNORE" do
    Iconv.conv("ISO-8859-1//IGNORE", "UTF-8", "ol\303\251").should == "ol\351"
    Iconv.conv("ISO-8859-1", "UTF-8//IGNORE", "ol\303\251").should == "ol\351"
  end

  it "aproximates undefined characters if encoding parameter contain the flag //TRANSLIT" do
    Iconv.conv("ISO-8859-1//TRANSLIT", "UTF-8", "ol\303\251").should == "ol\351"
  end
end
