shared :argf_filename do |cmd|
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
    it "returns the current file name on each file" do
      ARGFSpecs.file_args('file1.txt', 'file2.txt')

      res = []
      # returns first current file even when not yet open
      begin
        res << ARGF.send(cmd)
      end while ARGF.gets
      # returns last current file even when closed
      res << ARGF.send(cmd)
      res.collect { |f| File.expand_path(f) }.should == 
        [@file1, @file1, @file1, @file2, @file2, @file2].collect { |f| File.expand_path(f)}
    end
  
    # NOTE: this test assumes that fixtures files have two lines each
    # SO DO NOT modify the fixture files!!!
    it "it sets the $FILENAME global variable with the current file name on each file" do
      ARGFSpecs.file_args('file1.txt', 'file2.txt')
      res = []
      while ARGF.gets
        res << $FILENAME
      end 
      # returns last current file even when closed
      res << $FILENAME
      res.collect { |f| File.expand_path(f) }.should == 
        [@file1, @file1, @file2, @file2, @file2].collect { |f| File.expand_path(f)}
    end
  end
  
end