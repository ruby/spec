require File.dirname(__FILE__) + '/../../spec_helper'
require 'strscan'

describe "StringScanner#getch" do
  it "scans one character and returns it" do
    s = StringScanner.new('abc')
    s.getch.should == "a"
    s.getch.should == "b"
    s.getch.should == "c"
  end

  it "is multi-byte character sensitive" do
    begin
        old, $KCODE = $KCODE, 'EUC'
        src = "\244\242" # Japanese hira-kana "A" in EUC-JP
        src.force_encoding('EUC-JP') if ''.respond_to?(:force_encoding)
        s = StringScanner.new(src)
        s.getch.should == src
    ensure
      $KCODE = old
    end
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

  it "does not accept any arguments" do
    s = StringScanner.new('abc')
    lambda {
      s.getch(5)
    }.should raise_error(ArgumentError, /wrong .* arguments/)
  end

end
