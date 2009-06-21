require File.dirname(__FILE__) + '/../fixtures/classes'

ruby_version_is "1.9" do
  describe "Encoding::UndefinedConversionError#source_encoding" do
    before(:each) do
      @exception = EncodingSpecs::UndefinedConversionError.exception
    end

    it "returns an Encoding object" do
      @exception.source_encoding.should be_an_instance_of(Encoding)
    end

    it "is equal to the source encoding of the object that raised it" do
      @exception.source_encoding.should == Encoding::UTF_8
    end
  end
end
