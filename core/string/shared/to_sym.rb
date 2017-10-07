describe :string_to_sym, shared: true do
  it "returns the symbol corresponding to self" do
    "Koala".send(@method).should == :Koala
    'cat'.send(@method).should == :cat
    '@cat'.send(@method).should == :@cat
    'cat and dog'.send(@method).should == :"cat and dog"
    "abc=".send(@method).should == :abc=
  end

  it "does not special case +(binary) and -(binary)" do
    "+(binary)".send(@method).should == :"+(binary)"
    "-(binary)".send(@method).should == :"-(binary)"
  end

  it "does not special case certain operators" do
    [ ["!@", :"!@"],
      ["~@", :"~@"],
      ["!(unary)", :"!(unary)"],
      ["~(unary)", :"~(unary)"],
      ["+(unary)", :"+(unary)"],
      ["-(unary)", :"-(unary)"]
    ].should be_computed_by(@method)
  end

  it "returns a US-ASCII Symbol for a UTF-8 String containing only US-ASCII characters" do
    sym = "foobar".send(@method)
    sym.encoding.should == Encoding::US_ASCII
    sym.should == :"foobar"
  end

  it "returns a US-ASCII Symbol for a binary String containing only US-ASCII characters" do
    sym = "foobar".b.send(@method)
    sym.encoding.should == Encoding::US_ASCII
    sym.should == :"foobar"
  end

  it "returns a UTF-8 Symbol for a UTF-8 String containing non US-ASCII characters" do
    sym = "il était une fois".send(@method)
    sym.encoding.should == Encoding::UTF_8
    sym.should == :"il était une #{'fois'}"
  end

  it "returns a UTF-16LE Symbol for a UTF-16LE String containing non US-ASCII characters" do
    utf16_str = "UtéF16".encode(Encoding::UTF_16LE)
    sym = utf16_str.send(@method)
    sym.encoding.should == Encoding::UTF_16LE
    sym.to_s.should == utf16_str
  end

  it "returns a binary Symbol for a binary String containing non US-ASCII characters" do
    binary_string = "binarí".b
    sym = binary_string.send(@method)
    sym.encoding.should == Encoding::BINARY
    sym.to_s.should == binary_string
  end

  it "raises an EncodingError for UTF-8 String containing invalid bytes" do
    invalid_utf8 = "\xC3"
    invalid_utf8.valid_encoding?.should == false
    -> {
      invalid_utf8.send(@method)
    }.should raise_error(EncodingError, /invalid/)
  end
end
