require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'

describe "ARGF.read" do
  before :each do
    ARGV.clear
    @contents_file1 = File.read(File.dirname(__FILE__) + '/fixtures/file1.txt')    
    @contents_file2 = File.read(File.dirname(__FILE__) + '/fixtures/file2.txt')
    @contents_stdin = File.read(File.dirname(__FILE__) + '/fixtures/stdin.txt')
  end

  after :each do
    # Close any open file (catch exception if already closed)
    ARGF.close rescue nil
  end
  
  it "reads the contents of a file" do
    ARGFSpecs.file_args('file1.txt')
    ARGF.read().should == @contents_file1
  end

  it "treats first nil argument as no length limit" do
    ARGFSpecs.file_args('file1.txt')
    ARGF.read(nil).should == @contents_file1
  end
  
  it "treats second nil argument as no output buffer" do
    ARGFSpecs.file_args('file1.txt')
    ARGF.read(nil, nil).should == @contents_file1
  end
  
  it "treats second argument as an output buffer" do
    ARGFSpecs.file_args('file1.txt')
    buffer = ""
    ARGF.read(nil, buffer)
    buffer.should == @contents_file1
  end
  
  it "reads a number of bytes from the first file" do
    ARGFSpecs.file_args('file1.txt')
    ARGF.read(5).should == @contents_file1[0,5]
  end
  
  it "reads from a single file consecutively" do
    ARGFSpecs.file_args('file1.txt')
    ARGF.read(1).should == @contents_file1[0,1]
    ARGF.read(2).should == @contents_file1[1,2]
    ARGF.read(3).should == @contents_file1[3,3]
  end
  
  it "reads the contents of two files" do
    ARGFSpecs.file_args('file1.txt', 'file2.txt')
    ARGF.read.should ==  @contents_file1 + @contents_file2
  end
  
  it "reads the contents of one file and some characters from the second" do
    ARGFSpecs.file_args('file1.txt', 'file2.txt')
    len = @contents_file1.size + @contents_file2.size/2
    ARGF.read(len).should ==  (@contents_file1 + @contents_file2)[0,len]
  end
  
  it "reads across two files consecutively" do
    ARGFSpecs.file_args('file1.txt', 'file2.txt')
    ARGF.read(@contents_file1.length-2 ).should == @contents_file1[0..-3]
    ARGF.read(2+5).should == @contents_file1[-2..-1] + @contents_file2[0,5]
  end
  
  it "reads the contents of stdin" do
    ARGFSpecs.file_args('-')
    STDIN.reopen(File.dirname(__FILE__) + '/fixtures/stdin.txt')
    ARGF.read.should ==  @contents_stdin
  end
  
  it "reads a number of bytes from stdin" do
    ARGFSpecs.file_args('-')
    STDIN.reopen(File.dirname(__FILE__) + '/fixtures/stdin.txt')
    ARGF.read(10).should ==  @contents_stdin[0,10]
  end
  
  it "reads a number of bytes from stdin" do
    ARGFSpecs.file_args('-')
    STDIN.reopen(File.dirname(__FILE__) + '/fixtures/stdin.txt')
    ARGF.read(10).should ==  @contents_stdin[0,10]
  end
  
  it "reads the contents of one file and stdin" do
    ARGFSpecs.file_args('file1.txt', '-')
    STDIN.reopen(File.dirname(__FILE__) + '/fixtures/stdin.txt')
    ARGF.read.should ==  @contents_file1 + @contents_stdin
  end
  
  it "reads the contents of the same file twice" do
    ARGFSpecs.file_args('file1.txt', 'file1.txt')
    ARGF.read.should ==  @contents_file1 + @contents_file1
  end
  
  it "raises an IOError when contents read from stdin twice" do
    ARGFSpecs.file_args('-', '-')
    STDIN.reopen(File.dirname(__FILE__) + '/fixtures/stdin.txt')
    str = ""
    lambda { str = ARGF.read }.should raise_error(IOError)
    str.should ==  ""
  end
  
  not_supported_on :windows do  
    it "reads the contents of a special device file" do
      ARGFSpecs.file_args('/dev/zero')
      ARGF.read(100).should ==  "\000" * 100
    end
  end
  
  it "empties the files if in place edit mode is enabled and no output is generated" do
    # create fixture files that can be altered
    file1 = tmp('file1.txt'); file2 = tmp('file2.txt')
    File.open(file1,'w') { |fh| fh.write(@contents_file1) }
    File.open(file2,'w') { |fh| fh.write(@contents_file2) }
    ARGV.concat([file1, file2])
    $-i = ""  # activate in place edit mode
    ARGF.read.should ==  @contents_file1 + @contents_file2
    File.stat(file1).size.should == 0
    File.stat(file2).size.should == 0
    # cleanup the mess
    [file1, file2, file1+$-i, file2+$-i].each { |f| File.delete(f) if File.exists?(f)}
    # disable in place edit mode
    $-i = nil
  end
  
end