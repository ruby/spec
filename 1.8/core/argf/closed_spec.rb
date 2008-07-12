require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'

describe "ARGF.closed?" do
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
  
  # NOTE: this test assumes that fixtures files have two lines each
  # SO DO NOT modify the fixture files!!!
  it "says it is closed " do
    ARGFSpecs.file_args('file1.txt', 'file2.txt', '-')
    STDIN.reopen(File.dirname(__FILE__) + '/fixtures/stdin.txt')
    res = []
    3.times do
      res << ARGF.closed?
      ARGF.gets
      ARGF.gets
    end
    res << ARGF.closed?
    ARGF.gets
    res << ARGF.closed?

    res.should == [false, false, false, false, true]
  end
  
end