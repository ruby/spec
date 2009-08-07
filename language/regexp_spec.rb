require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'

describe "Literal Regexps" do
  it "matches against $_ (last input) in a conditional if no explicit matchee provided" do
    $_ = nil

    (true if /foo/).should_not == true

    $_ = "foo"

    (true if /foo/).should == true
  end

  it "yields a Regexp" do
    /Hello/.class.should == Regexp
  end
  
  it "caches the Regexp object" do
    rs = []
    2.times do |i|
      x = 1
      rs << /foo/
    end
    rs[0].should equal(rs[1])
  end

  it "throws SyntaxError for malformed literals" do
    lambda { eval('/(/') }.should raise_error(SyntaxError)
  end

  #############################################################################
  # %r
  #############################################################################

  it "supports paired delimiters with %r" do    
    LanguageSpecs.paired_delimiters.each do |p0, p1|
      eval("%r#{p0} foo #{p1}").should == / foo /
    end
  end
  
  it "supports grouping constructs that are also paired delimiters" do    
    LanguageSpecs.paired_delimiters.each do |p0, p1|
      eval("%r#{p0} () [c]{1} #{p1}").should == / () [c]{1} /      
    end
  end
  
  it "allows second part of paired delimiters to be used as non-paired delimiters" do    
    LanguageSpecs.paired_delimiters.each do |p0, p1|
      eval("%r#{p1} foo #{p1}").should == / foo /
    end
  end
  
  it "disallows first part of paired delimiters to be used as non-paired delimiters" do    
    LanguageSpecs.paired_delimiters.each do |p0, p1|
      lambda { eval("%r#{p0} foo #{p0}") }.should raise_error(SyntaxError)
    end
  end
  
  it "supports non-paired delimiters delimiters with %r" do    
    LanguageSpecs.non_paired_delimiters.each do |c|
      eval("%r#{c} foo #{c}").should == / foo /
    end
  end
  
  it "disallows alphabets as non-paired delimiter with %r" do    
    lambda { eval('%ra foo a') }.should raise_error(SyntaxError)
  end
  
  it "disallows spaces after %r and delimiter" do    
    lambda { eval('%r !foo!') }.should raise_error(SyntaxError)
  end
  
  it "allows unescaped / to be used with %r" do
    %r[/].to_s.should == /\//.to_s
  end
  
  
  #############################################################################
  # Specs for the matching semantics
  #############################################################################
    
  
  it 'supports . (any character except line terminator)' do
    # Basic matching
    /./.match("foo").to_a.should == ["f"]
    # Basic non-matching
    /./.match("").should be_nil
    /./.match("\n").should be_nil
    /./.match("\0").to_a.should == ["\0"]
  end
  
  it 'supports . with /m' do
    # Basic matching
    /./m.match("\n").to_a.should == ["\n"]
  end
  
  it 'supports ()' do
    /(a)/.match("a").to_a.should == ["a", "a"]
  end
  
  
  it 'supports | (alternations)' do
    /a|b/.match("a").to_a.should == ["a"]
  end
  
  it 'supports (?= ) (positive lookahead)' do
    /foo.(?=bar)/.match("foo1 foo2bar").to_a.should == ["foo2"]
  end
  
  it 'supports (?! ) (negative lookahead)' do
    /foo.(?!bar)/.match("foo1bar foo2").to_a.should == ["foo2"]
  end
  
  it 'supports (?> ) (embedded subexpression)' do
    /(?>foo)(?>bar)/.match("foobar").to_a.should == ["foobar"]
    /(?>foo*)obar/.match("foooooooobar").should be_nil # it is possesive
  end
  
  it 'supports (?: ) (non-capturing group)' do
    /(?:foo)(bar)/.match("foobar").to_a.should == ["foobar", "bar"]
    # Parsing precedence
    /(?:xdigit:)/.match("xdigit:").to_a.should == ["xdigit:"]
  end
  
  it 'supports (?imx-imx) (inline modifiers)' do
    /(?i)foo/.match("FOO").to_a.should == ["FOO"]
    /foo(?i)/.match("FOO").should be_nil
    # Interaction with /i
    /(?-i)foo/i.match("FOO").should be_nil
    /foo(?-i)/i.match("FOO").to_a.should == ["FOO"]
    # Multiple uses
    /foo (?i)bar (?-i)baz/.match("foo BAR baz").to_a.should == ["foo BAR baz"]
    /foo (?i)bar (?-i)baz/.match("foo BAR BAZ").should be_nil
    
    /(?m)./.match("\n").to_a.should == ["\n"]
    /.(?m)/.match("\n").should be_nil
    # Interaction with /m
    /(?-m)./m.match("\n").should be_nil
    /.(?-m)/m.match("\n").to_a.should == ["\n"]
    # Multiple uses
    /. (?m). (?-m)./.match(". \n .").to_a.should == [". \n ."]
    /. (?m). (?-m)./.match(". \n \n").should be_nil
      
    /(?x) foo /.match("foo").to_a.should == ["foo"]
    / foo (?x)/.match("foo").should be_nil
    # Interaction with /x
    /(?-x) foo /x.match("foo").should be_nil
    / foo (?-x)/x.match("foo").to_a.should == ["foo"]
    # Multiple uses
    /( foo )(?x)( bar )(?-x)( baz )/.match(" foo bar baz ").to_a.should == [" foo bar baz ", " foo ", "bar", " baz "]
    /( foo )(?x)( bar )(?-x)( baz )/.match(" foo barbaz").should be_nil
    
    # Parsing
    /(?i-i)foo/.match("FOO").should be_nil
    /(?ii)foo/.match("FOO").to_a.should == ["FOO"]
    /(?-)foo/.match("foo").to_a.should == ["foo"]
    lambda { eval('/(?a)/') }.should raise_error(SyntaxError)
    lambda { eval('/(?o)/') }.should raise_error(SyntaxError)
  end
  
  it 'supports (?imx-imx:expr) (scoped inline modifiers)' do
    /foo (?i:bar) baz/.match("foo BAR baz").to_a.should == ["foo BAR baz"]
    /foo (?i:bar) baz/.match("foo BAR BAZ").should be_nil   
    /foo (?-i:bar) baz/i.match("foo BAR BAZ").should be_nil

    /. (?m:.) ./.match(". \n .").to_a.should == [". \n ."]
    /. (?m:.) ./.match(". \n \n").should be_nil
    /. (?-m:.) ./m.match("\n \n \n").should be_nil
      
    /( foo )(?x: bar )( baz )/.match(" foo bar baz ").to_a.should == [" foo bar baz ", " foo ", " baz "]
    /( foo )(?x: bar )( baz )/.match(" foo barbaz").should be_nil
    /( foo )(?-x: bar )( baz )/x.match("foo bar baz").to_a.should == ["foo bar baz", "foo", "baz"]
    
    # Parsing
    /(?i-i:foo)/.match("FOO").should be_nil
    /(?ii:foo)/.match("FOO").to_a.should == ["FOO"]
    /(?-:)foo/.match("foo").to_a.should == ["foo"]
    lambda { eval('/(?a:)/') }.should raise_error(SyntaxError)
    lambda { eval('/(?o:)/') }.should raise_error(SyntaxError)
  end
  
  it 'supports (?# )' do
    /foo(?#comment)bar/.match("foobar").to_a.should == ["foobar"]
    /foo(?#)bar/.match("foobar").to_a.should == ["foobar"]
  end
  
  it 'supports \<n> (backreference to previous group match)' do
    /(foo.)\1/.match("foo1foo1").to_a.should == ["foo1foo1", "foo1"]
    /(foo.)\1/.match("foo1foo2").should be_nil
  end
  
  not_compliant_on :ironruby do
    it 'resets nested \<n> backreference before match of outer subexpression' do
      /(a\1?){2}/.match("aaaa").to_a.should == ["aa", "a"]
    end
  end
  
  #############################################################################
  # Modifiers
  #############################################################################

  it 'supports /i (case-insensitive)' do
    /foo/i.match("FOO").to_a.should == ["FOO"]
  end
  
  it 'supports /m (multiline)' do
    /foo.bar/m.match("foo\nbar").to_a.should == ["foo\nbar"]
    /foo.bar/.match("foo\nbar").should be_nil
  end
  
  it 'supports /x (extended syntax)' do
    /\d +/x.match("abc123").to_a.should == ["123"] # Quantifiers can be separated from the expression they apply to
  end
  
  it 'supports /o (once)' do
    2.times do |i|
      /#{i}/o.should == /0/
    end
  end
  
  it 'invokes substitutions for /o only once' do
    ScratchPad.record []
    to_s_callback = Proc.new do
      ScratchPad << :to_s_callback
      "class_with_to_s"
    end
    o = LanguageSpecs::ClassWith_to_s.new(to_s_callback)
    2.times { /#{o}/o }
    ScratchPad.recorded.should == [:to_s_callback]
  end
 
  ruby_version_is "" ... "1.9" do 
    it 'does not do thread synchronization for /o' do
      ScratchPad.record []
      
      to_s_callback2 = Proc.new do
        ScratchPad << :to_s_callback2
        "class_with_to_s2"
      end
  
      to_s_callback1 = Proc.new do
        ScratchPad << :to_s_callback1
        t2 = Thread.new do
          o2 = LanguageSpecs::ClassWith_to_s.new(to_s_callback2)
          ScratchPad << LanguageSpecs.get_regexp_with_substitution(o2)
        end
        t2.join
        "class_with_to_s1"
      end
      
      o1 = LanguageSpecs::ClassWith_to_s.new(to_s_callback1)
      ScratchPad << LanguageSpecs.get_regexp_with_substitution(o1)
  
      ScratchPad.recorded.should == [:to_s_callback1, :to_s_callback2, /class_with_to_s2/, /class_with_to_s2/]
    end
  end
  
  it 'supports modifier combinations' do
    /foo/imox.match("foo").to_a.should == ["foo"]
    /foo/imoximox.match("foo").to_a.should == ["foo"]

    lambda { eval('/foo/a') }.should raise_error(SyntaxError)
  end
  
  #############################################################################
  # Encodings
  #############################################################################

  not_compliant_on :ruby19, :macruby do
    it 'supports /e (EUC encoding)' do
      /./e.match("\303\251").to_a.should == ["\303\251"]
    end
    
    it 'supports /n (Normal encoding)' do
      /./n.match("\303\251").to_a.should == ["\303"]
    end
    
    it 'supports /s (SJIS encoding)' do
      /./s.match("\303\251").to_a.should == ["\303"]
    end
    
    it 'supports /u (UTF8 encoding)' do
      /./u.match("\303\251").to_a.should == ["\303\251"]
    end
    
    it 'selects last of multiple encoding specifiers' do
      /foo/ensuensuens.should == /foo/s
    end
  end

  #############################################################################
  # Back-refs
  #############################################################################

  it 'saves match data in the $~ pseudo-global variable' do
    "hello" =~ /l+/
    $~.to_a.should == ["ll"]
  end

  it 'saves captures in numbered $[1-9] variables' do
    "1234567890" =~ /(1)(2)(3)(4)(5)(6)(7)(8)(9)(0)/
    $~.to_a.should == ["1234567890", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
    $1.should == "1"
    $2.should == "2"
    $3.should == "3"
    $4.should == "4"
    $5.should == "5"
    $6.should == "6"
    $7.should == "7"
    $8.should == "8"
    $9.should == "9"
  end

  it 'will not clobber capture variables across threads' do
    cap1, cap2, cap3 = nil
    "foo" =~ /(o+)/
    cap1 = [$~.to_a, $1]
    Thread.new do
      cap2 = [$~.to_a, $1]
      "bar" =~ /(a)/
      cap3 = [$~.to_a, $1]
    end.join
    cap4 = [$~.to_a, $1]
    cap1.should == [["oo", "oo"], "oo"]
    cap2.should == [[], nil]
    cap3.should == [["a", "a"], "a"]
    cap4.should == [["oo", "oo"], "oo"]
  end
end

language_version __FILE__, "regexp"
