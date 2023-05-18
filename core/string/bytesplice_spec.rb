require_relative '../../spec_helper'

describe "String#bytesplice" do
  ruby_version_is "3.2" do
    it "accepts index, length and replacement string as arguments and returns replaced string" do
      "string".bytesplice(0, 3, "xxx").should == "xxxing"
      "string".bytesplice(-3, 3, "xxx").should == "strxxx"
      "string".bytesplice(-6, 0, "xxx").should == "xxxstring"
      "string".bytesplice(3, 0, "xxx").should == "strxxxing"
    end

    it "accepts range and replacement string as arguments and returns replaced string" do
      "string".bytesplice(0...3, "xxx").should == "xxxing"
      "string".bytesplice(-3...3, "xxx").should == "strxxxing"
      "string".bytesplice(-6...0, "xxx").should == "xxxstring"
      "string".bytesplice(3..6, "xxx").should == "strxxx"
    end

    it "replaces on an empty string" do
      "".bytesplice(0, 0, "xxx").should == "xxx"
      "".bytesplice(0, 0, "").should == ""
    end

    it "adjust string length if is not the same as replacement string" do
      "string".bytesplice(0..-1, "xxx").should == "xxx"
      "string".bytesplice(0, 6, "xxx").should == "xxx"
    end

    it "mutates self" do
      s = "string"
      s.bytesplice(2, 1, "xxx").should == "stxxxing"
      s.should == "stxxxing"
    end

    it "raises IndexError if index argument is out of range" do
      -> {
        "string".bytesplice(-7, 0, "xxx")
      }.should raise_error(IndexError, "index -7 out of string")

      -> {
        "string".bytesplice(7, 0, "xxx")
      }.should raise_error(IndexError, "index 7 out of string")
    end

    it "raises RangeError if range argument is out of range" do
      -> {
        "string".bytesplice(-7...-7, "xxx")
      }.should raise_error(RangeError, "-7...-7 out of range")
    end

    it "raises TypeError if index is provided withoput length argument" do
      -> {
        "string".bytesplice(0, "xxx")
      }.should raise_error(TypeError, "wrong argument type Integer (expected Range)")
    end

    it "raises FrozenError when string is frozen" do
      s = "string".freeze

      -> {
        s.bytesplice(2, 1, "xxx")
      }.should raise_error(FrozenError, "can't modify frozen String: \"string\"")
    end

    context "with multibyte characters" do
      it "accepts index, length and replacement string as arguments and returns replaced string" do
        "こんにちは".bytesplice(0, 3, "xxx").should == "xxxんにちは"
        "こんにちは".bytesplice(-3, 3, "xxx").should == "こんにちxxx"
        "こんにちは".bytesplice(-6, 0, "xxx").should == "こんにxxxちは"
        "こんにちは".bytesplice(3, 0, "xxx").should == "こxxxんにちは"
      end

      it "accepts range and replacement string as arguments and returns replaced string" do
        "こんにちは".bytesplice(0...3, "xxx").should == "xxxんにちは"
        "こんにちは".bytesplice(-3...3, "xxx").should == "こんにちxxxは"
        "こんにちは".bytesplice(-6...0, "xxx").should == "こんにxxxちは"
      end

      it "raises IndexError if index is out of byte size boundary" do
        -> {
          "こんにちは".bytesplice(-16, 0, "xxx")
        }.should raise_error(IndexError, "index -16 out of string")
      end

      it "raises IndexError if index is not on a codepoint boundary" do
        -> {
          "こんにちは".bytesplice(1, 0, "xxx")
        }.should raise_error(IndexError, "offset 1 does not land on character boundary")
      end

      it "raises IndexError when length is not matching the codepoint boundary" do
        -> {
          "こんにちは".bytesplice(0, 1, "xxx")
        }.should raise_error(IndexError, "offset 1 does not land on character boundary")

        -> {
          "こんにちは".bytesplice(0, 2, "xxx")
        }.should raise_error(IndexError, "offset 2 does not land on character boundary")
      end

      it "treats negative length for range as 0" do
        "こんにちは".bytesplice(0...-100, "xxx").should == "xxxこんにちは"
        "こんにちは".bytesplice(3...-100, "xxx").should == "こxxxんにちは"
        "こんにちは".bytesplice(-15...-100, "xxx").should == "xxxこんにちは"
      end

      it "deals with a different encoded argument" do
        s = "こんにちは"
        s.encoding.should == Encoding::UTF_8
        sub = "xxxxxx"
        sub.force_encoding(Encoding::US_ASCII)

        result = s.bytesplice(0, 3, sub)
        result.should == "xxxxxxんにちは"
        result.encoding.should == Encoding::UTF_8

        s = "xxxxxx"
        s.force_encoding(Encoding::US_ASCII)
        sub = "こんにちは"
        sub.encoding.should == Encoding::UTF_8

        result = s.bytesplice(0, 3, sub)
        result.should == "こんにちはxxx"
        result.encoding.should == Encoding::UTF_8
      end
    end
  end
end
