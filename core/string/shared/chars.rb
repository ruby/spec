# encoding: utf-8
require File.dirname(__FILE__) + '/../../../spec_helper'
require File.dirname(__FILE__) + '/../fixtures/classes'

describe :string_chars, :shared => true do
  it "passes each char in self to the given block" do
    a = []
    "hello".send(@method) { |c| a << c }
    a.should == ['h', 'e', 'l', 'l', 'o']
  end

  ruby_bug 'redmine #1487', '1.9.1' do
    it "returns self" do
      s = StringSpecs::MyString.new "hello"
      s.send(@method){}.should equal(s)
    end
  end

  it "returns an enumerator when no block given" do
    enum = "hello".send(@method)
    enum.should be_kind_of(enumerator_class)
    enum.to_a.should == ['h', 'e', 'l', 'l', 'o']
  end


  it "is unicode aware" do
    before = $KCODE
    $KCODE = "UTF-8"
    "\303\207\342\210\202\303\251\306\222g".send(@method).to_a.should == ["\303\207", "\342\210\202", "\303\251", "\306\222", "g"]
    $KCODE = before
  end
  
  ruby_version_is "1.9" do
    it "works with multibyte characters" do
      s = "\u{8987}".force_encoding("UTF-8")
      s.bytesize.should == 3
      s.send(@method).to_a.should == [s]
    end
  end
end  
