# -*- encoding: binary -*-
require_relative '../../spec_helper'
require_relative 'shared/extract_range'
require 'strscan'

describe "StringScanner#getch" do
  it "scans one character and returns it" do
    s = StringScanner.new('abc')
    s.getch.should == "a"
    s.getch.should == "b"
    s.getch.should == "c"
  end

  it "is multi-byte character sensitive" do
    # Japanese hiragana "A" in EUC-JP
    src = "\244\242".dup.force_encoding("euc-jp")

    s = StringScanner.new(src)
    s.getch.should == src
  end

  it "returns nil at the end of the string" do
    # empty string case
    s = StringScanner.new('')
    s.getch.should == nil
    s.getch.should == nil

    # non-empty string case
    s = StringScanner.new('a')
    s.getch # skip one
    s.getch.should == nil
  end

  it_behaves_like :extract_range, :getch
end
