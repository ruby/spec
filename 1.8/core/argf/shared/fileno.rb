shared :argf_fileno do |cmd|
  describe "ARGF.#{cmd}" do
    before :each do
      ARGV.clear
      @file1 = File.dirname(__FILE__) + '/../fixtures/file1.txt'
      @file2 = File.dirname(__FILE__) + '/../fixtures/file2.txt'
      @contents_file1 = File.read(@file1)    
      @contents_file2 = File.read(@file2)
    end

    after :each do
      # Close any open file (catch exception if already closed)
      ARGF.close rescue nil
    end
  
    # NOTE: this test assumes that fixtures files have two lines each
    # SO DO NOT modify the fixture files!!!
    it "returns the current file number on each file" do
      ARGFSpecs.file_args('file1.txt', 'file2.txt')

      res = []
      # returns first current file even when not yet open
      while ARGF.gets
        res << ARGF.send(cmd)
      end 
      # returns last current file even when closed
      res.collect {|d| d.class}.should == [Fixnum, Fixnum, Fixnum, Fixnum]
    end
  
    it "raises ArgumentError (no stream) when called on a closed stream" do
      ARGFSpecs.file_args('file1.txt')
      ARGF.read # read everything at once. Stream closed.
      lambda { ARGF.send(cmd) }.should raise_error(ArgumentError)
    end
  end

end