# -*- encoding: utf-8 -*-
require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is "2.2" do
  describe "String#unicode_normalized?" do
    it "returns true if str is in Unicode normalization form (nfc)" do
      str = "a\u0300"
      str.unicode_normalized?(:nfc).should be_false
      str.unicode_normalize!(:nfc)
      str.unicode_normalized?(:nfc).should be_true
    end

    it "returns true if str is in Unicode normalization form (nfd)" do
      str = "a\u00E0"
      str.unicode_normalized?(:nfd).should be_false
      str.unicode_normalize!(:nfd)
      str.unicode_normalized?(:nfd).should be_true
    end

    it "returns true if str is in Unicode normalization form (nfkc)" do
      str = "a\u0300"
      str.unicode_normalized?(:nfkc).should be_false
      str.unicode_normalize!(:nfkc)
      str.unicode_normalized?(:nfkc).should be_true
    end

    it "returns true if str is in Unicode normalization form (nfkd)" do
      str = "a\u00E0"
      str.unicode_normalized?(:nfkd).should be_false
      str.unicode_normalize!(:nfkd)
      str.unicode_normalized?(:nfkd).should be_true
    end
  end
end
