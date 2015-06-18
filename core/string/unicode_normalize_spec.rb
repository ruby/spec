ruby_version_is "2.2" do
  describe "String#unicode_normalize" do
    it "returns nfc normalized form of string" do
      "a\u0300".unicode_normalize.should == "à"
    end

    it "returns nfd normalized form of string" do
      "a\u0300".unicode_normalize(:nfd).should == "à"
    end

    it "returns nfkc normalized form of string" do
      "a\u0300".unicode_normalize(:nfkc).should == "à"
    end

    it "returns nfkd normalized form of string" do
      "a\u0300".unicode_normalize(:nfkd).should == "à"
    end

    it "raises an Encoding::CompatibilityError if string is not unicode encoding" do
      lambda do
        eval("\xE0".force_encoding("ISO-8859-1").unicode_normalize(:nfd))
      end.should raise_error(Encoding::CompatibilityError)
    end
  end

  describe "String#unicode_normalize!" do
    it "modified original string" do
      str = "a\u0300"
      str.unicode_normalize!

      str.should_not == "a\u0300"
      str.should == "à"
    end
  end

  describe "unicode_normalized?" do
    it "returns true if str is in Unicode normalization form" do
      str = "a\u0300"
      str.unicode_normalized?.should be_false

      str.unicode_normalize!
      str.unicode_normalized?.should be_true
    end
  end
end
