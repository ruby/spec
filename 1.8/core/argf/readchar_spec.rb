require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'

describe "ARGF.readchar" do
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
  
  it "reads each char of files" do
    ARGFSpecs.file_args('file1.txt', 'file2.txt', '-')
    STDIN.reopen(File.dirname(__FILE__) + '/fixtures/stdin.txt')
    total_len = @contents_file1.size + @contents_file2.size + @contents_stdin.size
    stg = ""
    for i in 1..total_len
        stg << ARGF.readchar
    end
    stg.should == @contents_file1 + @contents_file2 + @contents_stdin
  end
  
  it "raises EOFError when end of stream reached" do
    ARGFSpecs.file_args('file1.txt', 'file2.txt', '-')
    STDIN.reopen(File.dirname(__FILE__) + '/fixtures/stdin.txt')
    lambda { while c = ARGF.readchar;end }.should raise_error(EOFError)
  end
end