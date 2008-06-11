shared :stringio_each do |cmd|
  describe "StringIO##{cmd}" do
    before(:each) do
      @io = StringIO.new("a b c d e\n1 2 3 4 5") 
    end

    it "yields each line by default" do
      seen = []
      @io.send(cmd) {|s| seen << s}.should == @io
      seen.should == ["a b c d e\n", "1 2 3 4 5"]
    end

    it "supports a separator argument" do
      seen = []
      @io.send(cmd, ' ') {|s| seen << s}.should == @io
      seen.should == ["a ", "b ", "c ", "d ", "e\n1 ", "2 ", "3 ", "4 ", "5"]
    end

    it "returns self" do
      @io.send(cmd) {}.should equal(@io)
    end

    ruby_version_is "" ... "1.8.7" do
      it "yields a LocalJumpError when passed no block" do
        lambda { @io.send(cmd) }.should raise_error(LocalJumpError)
      end
    end

    ruby_version_is "1.8.7" do
      it "returns an Enumerator when passed no block" do
        enum = @io.send(cmd)
        enum.instance_of?(Enumerable::Enumerator).should be_true
        
        seen = []
        enum.each { |b| seen << b }
        seen.should == ["a b c d e\n", "1 2 3 4 5"]
      end
    end
  end

  describe "StringIO##{cmd} when in write-only mode" do
    it "raises an IOError" do
      io = StringIO.new("a b c d e", "w")
      lambda { io.send(cmd) { |b| b } }.should raise_error(IOError)

      io = StringIO.new("a b c d e")
      io.close_read
      lambda { io.send(cmd) { |b| b } }.should raise_error(IOError)
    end
  end
end
