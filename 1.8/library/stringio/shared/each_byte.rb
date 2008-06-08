shared :stringio_each_byte do |cmd|
  describe "StringIO##{cmd}" do
    before(:each) do
      @io = StringIO.new("xyz")
    end

    it "yields each character code in turn" do
      seen = []
      @io.send(cmd) { |b| seen << b }
      seen.should == [120, 121, 122]
    end

    ruby_version_is "" ... "1.8.7" do
      it "returns nil" do
        @io.send(cmd) {}.should be_nil
      end
    end

    ruby_version_is "1.8.7" do
      it "returns self" do
        @io.send(cmd) {}.should equal(@io)
      end
    end

    it "raises an IOError unless the IO is open for reading" do
      @io.close_read
      lambda { @io.send(cmd) {|b| b } }.should raise_error(IOError)
    end
  end
end