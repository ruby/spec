shared :strscan_get_byte do |cmd|
  describe "StringScanner##{cmd}" do
    it "scans one byte and returns it" do
      s = StringScanner.new('ab')
      s.send(cmd).should == 'a'
      s.send(cmd).should == 'b'
      s.send(cmd).should == nil
    end

    it "is not multi-byte character sensitive" do
      s = StringScanner.new("\244\242")
      s.send(cmd).should == "\244"
      s.send(cmd).should == "\242"
      s.send(cmd).should == nil
    end
  end
end
