require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'

describe "ARGF.getc" do
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
    stg = ""
    while c = ARGF.getc
      stg << c
    end
    stg.should == @contents_file1 + @contents_file2 + @contents_stdin
  end
  
  it "returns nil when end of stream reached" do
    ARGFSpecs.file_args('file1.txt', 'file2.txt', '-')
    STDIN.reopen(File.dirname(__FILE__) + '/fixtures/stdin.txt')
    ARGF.read # read all files at once
    ARGF.getc.should == nil
  end
end