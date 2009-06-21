require File.dirname(__FILE__) + '/../../../spec_helper'

describe "Encoding::Converter#replacement" do
  it "returns '?' in US-ASCII when the destination encoding is not UTF-8" do
    ec = Encoding::Converter.new("utf-8", "us-ascii")
    ec.replacement.should == "?"
    ec.replacement.encoding.should == Encoding::US_ASCII

    ec = Encoding::Converter.new("utf-8", "sjis")
    ec.replacement.should == "?"
    ec.replacement.encoding.should == Encoding::US_ASCII
  end

  it "returns \u{fffd} when the destination encoding is UTF-8" do
    ec = Encoding::Converter.new("us-ascii", "utf-8")
    ec.replacement.should == "\u{fffd}".force_encoding('utf-8')
    ec.replacement.encoding.should == Encoding::UTF_8
  end
end

describe "Encoding::Converter#replacement=" do
  it "needs to be reviewed for spec completeness"
end
