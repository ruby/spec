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
