require File.dirname(__FILE__) + '/../fixtures/classes'

ruby_version_is "1.9" do
  describe "Encoding::UndefinedConversionError#source_encoding_name" do
    before(:each) do
      @exception = EncodingSpecs::UndefinedConversionError.exception
    end

    it "returns a String" do
      @exception.source_encoding_name.should be_an_instance_of(String)
    end

    it "is equal to the source encoding name of the object that raised it" do
      @exception.source_encoding_name.should == "UTF-8"
    end
  end
end
