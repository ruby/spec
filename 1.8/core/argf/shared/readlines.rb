shared :argf_readlines do |cmd|
  describe "ARGF.#{cmd}" do
    before :each do
      ARGV.clear
      @file1 = File.dirname(__FILE__) + '/../fixtures/file1.txt'
      @file2 = File.dirname(__FILE__) + '/../fixtures/file2.txt'
      @stdin = File.dirname(__FILE__) + '/../fixtures/stdin.txt'
      @contents_file1 = File.read(@file1)    
      @contents_file2 = File.read(@file2)
      @contents_stdin = File.read(@stdin)
    end

    after :each do
      # Close any open file (catch exception if already closed)
      ARGF.close rescue nil
    end
  
    it "reads all lines of all files" do
      ARGFSpecs.file_args('file1.txt', 'file2.txt', '-')
      STDIN.reopen(@stdin)
      all_lines = (@contents_file1 + @contents_file2 + @contents_stdin).split($/).collect { |l| l+$/ }
      ary = ARGF.send(cmd)
      ary.should == all_lines
    end
  
    it "returns nil when end of stream reached" do
      ARGFSpecs.file_args('file1.txt', 'file2.txt', '-')
      STDIN.reopen(@stdin)
      ARGF.read # read all files at once
      ARGF.send(cmd).should == nil
    end
  end
end