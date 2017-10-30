describe :kernel_sprintf_encoding, shared: true do
  def format(*args)
    @method.call(*args)
  end

  it "returns a String in the same encoding as the format String if compatible" do
    string = "%s".force_encoding(Encoding::KOI8_U)
    result = format(string, "dogs")
    result.encoding.should equal(Encoding::KOI8_U)
  end

  it "returns a String in the argument's encoding if format encoding is more restrictive" do
    string = "foo %s".force_encoding(Encoding::US_ASCII)
    argument = "b\303\274r".force_encoding(Encoding::UTF_8)

    result = format(string, argument)
    result.encoding.should equal(Encoding::UTF_8)
  end
end
