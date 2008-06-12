shared :stringio_readchar do |cmd|
  describe "StringIO##{cmd}" do
    before(:each) do
      @io = StringIO.new("example")
    end

    it "reads the next 8-bit byte from self's current position" do
      @io.send(cmd).should == ?e

      @io.pos = 4
      @io.send(cmd).should == ?p
    end

    it "correctly updates the current position" do
      @io.send(cmd)
      @io.pos.should == 1

      @io.send(cmd)
      @io.pos.should == 2
    end

    it "raises an EOFError when self is at the end" do
      @io.pos = 7
      lambda { @io.send(cmd) }.should raise_error(EOFError)
    end
  end
end