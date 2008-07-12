require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'

describe "ARGF.file" do
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
  it "returns the current file object on each file" do
    ARGFSpecs.file_args('file1.txt', 'file2.txt')
    res = []
    # returns first current file even when not yet open
    begin
      res << ARGF.file.path
    end while ARGF.gets
    # returns last current file even when closed
    res << ARGF.file.path
    res.should == %w{file1 file1 file1 file2 file2 file2}.collect { |bn| File.join(File.dirname(__FILE__), 'fixtures', bn+'.txt')}
  end

end