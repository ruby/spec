shared :stringio_eof do |cmd|
  describe "StringIO##{cmd}" do
    before(:each) do
      @io = StringIO.new("eof")
    end

    it "returns true when self's position is at the end" do
      @io.pos = 3
      @io.send(cmd).should == true
    end

    it "returns false when self's position is not at the end" do
      @io.pos = 0
      @io.send(cmd).should == false

      @io.pos = 1
      @io.send(cmd).should == false

      @io.pos = 2
      @io.send(cmd).should == false
    end
  end
end
