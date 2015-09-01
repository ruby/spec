require File.expand_path('../../../spec_helper', __FILE__)
require 'objspace'

describe "ObjectSpace.memsize_of" do
  it "test memsize_of" do
    ObjectSpace.memsize_of(true).should == 0
    ObjectSpace.memsize_of(nil).should == 0
    ObjectSpace.memsize_of(1).should == 0
    ObjectSpace.memsize_of(Object.new).should be_kind_of(Integer)
    ObjectSpace.memsize_of(Class).should be_kind_of(Integer)
    ObjectSpace.memsize_of("").should be_kind_of(Integer)
    ObjectSpace.memsize_of([]).should be_kind_of(Integer)
    ObjectSpace.memsize_of({}).should be_kind_of(Integer)
    ObjectSpace.memsize_of(//).should be_kind_of(Integer)
    f = File.new(__FILE__)
    ObjectSpace.memsize_of(f).should be_kind_of(Integer)
    f.close
    ObjectSpace.memsize_of(/a/.match("a")).should be_kind_of(Integer)
    ObjectSpace.memsize_of(Struct.new(:a)).should be_kind_of(Integer)

    (
      ObjectSpace.memsize_of(Regexp.new("(a)"*1000).match("a"*1000)) \
      > \
      ObjectSpace.memsize_of(//.match(""))
    ).should == true
  end

  it "memsize_of root shared string" do
    a = "hello" * 5
    b = a.dup
    c = nil
    ObjectSpace.each_object(String) {|x| break c = x if x == a and x.frozen?}
    rv_size = GC::INTERNAL_CONSTANTS[:RVALUE_SIZE]
    [rv_size, rv_size, 26 + rv_size].should == [a, b, c].map {|x| ObjectSpace.memsize_of(x)}
  end

  it "argf memsize" do
    size = ObjectSpace.memsize_of(ARGF)
    size.should be_kind_of Integer
    (size > 0).should == true
    argf = ARGF.dup
    argf.inplace_mode = nil
    size = ObjectSpace.memsize_of(argf)
    argf.inplace_mode = "inplace_mode_suffix"
    ObjectSpace.memsize_of(argf).should == (size + 20)
  end
end
