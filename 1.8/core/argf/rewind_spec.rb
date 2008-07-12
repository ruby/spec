require File.dirname(__FILE__) + '/fixtures/classes'

describe "ARGF.rewind" do
  before :each do
    ARGV.clear
    @contents_file1 = File.read(File.dirname(__FILE__) + '/fixtures/file1.txt')    
    @contents_file2 = File.read(File.dirname(__FILE__) + '/fixtures/file2.txt')
  end

  after :each do
    # Close any open file (catch exception if already closed)
    ARGF.close rescue nil
  end
    
  # NOTE: this test assumes that fixtures files have two lines each
  # SO DO NOT modify the fixture files!!!
  it "goes back to beginning of current file" do
    ARGFSpecs.file_args('file1.txt', 'file2.txt')
    linef1_1, linef1_2 =  @contents_file1.split($/).collect { |l| l+$/ }
    linef2_1, linef2_2 =  @contents_file2.split($/).collect { |l| l+$/ }

    res =[]
    ARGF.gets;
    ARGF.rewind; res << ARGF.gets
    ARGF.gets # finish reading file1
    ARGF.gets
    ARGF.rewind; res << ARGF.gets

    res.should == [linef1_1, linef2_1]
    
  end
  
  it "raises ArgumentError when end of stream reached" do
    ARGFSpecs.file_args('file1.txt', 'file2.txt')
    ARGF.read 
    lambda { ARGF.rewind }.should raise_error(ArgumentError)
  end

end