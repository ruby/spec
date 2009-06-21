require File.dirname(__FILE__) + '/../fixtures/classes'

ruby_version_is "1.9" do
  describe "Encoding::InvalidByteSequenceError#destination_encoding_name" do
    before(:each) do
      @exception, = EncodingSpecs::InvalidByteSequenceError.exception
    end

    it "returns a String" do
      @exception.destination_encoding_name.should be_an_instance_of(String)
    end

    it "is equal to the destination encoding name of the object that raised it" do
      @exception.destination_encoding_name.should == "ISO-8859-1"
    end
  end
end
