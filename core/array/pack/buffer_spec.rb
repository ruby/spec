# encoding: ascii-8bit

require File.expand_path('../../../../spec_helper', __FILE__)

ruby_version_is '2.4' do
  describe "Aray#pack with `buffer` option" do
    it "returns specified buffer" do
      n = [ 65, 66, 67 ]
      buffer = " "*3
      result = n.pack("ccc", buffer: buffer)      #=> "ABC"
      result.object_id.should == buffer.object_id
    end

    it "raises TypeError exception if buffer is not String" do
      lambda { [65].pack("ccc", buffer: []) }.should raise_error(
        TypeError, "buffer must be String, not Array")
    end

    context "offset (@) is specified" do
      it 'keeps buffer content if it is longer than offset' do
        n = [ 65, 66, 67 ]
        buffer = "123456"
        n.pack("@3ccc", buffer: buffer).should == "123ABC"
      end

      it "fills the gap with \0 if buffer content is shorter than offset" do
        n = [ 65, 66, 67 ]
        buffer = "123"
        n.pack("@6ccc", buffer: buffer).should == "123\0\0\0ABC"
      end
    end
  end
end
