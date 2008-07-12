require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'

describe "ARGF.close" do
  before :each do
    ARGV.clear
    @contents_file1 = File.read(File.dirname(__FILE__) + '/fixtures/file1.txt')    
    @contents_file2 = File.read(File.dirname(__FILE__) + '/fixtures/file2.txt')
  end

  after :each do
    # Close any open file (catch exception if already closed)
    ARGF.close rescue nil
  end
  
  it "closes the current file and read the next one" do
    ARGFSpecs.file_args('file1.txt', 'file2.txt')
    ARGF.close
    ARGF.read.should == @contents_file2
  end
  
  it "reads one line from the first file, closes it and read the next one" do
    ARGFSpecs.file_args('file1.txt', 'file2.txt')
    ARGF.gets.should == @contents_file1.split($/).first+$/
    ARGF.close
    ARGF.read.should == @contents_file2
  end
  
end