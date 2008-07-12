require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'
require File.dirname(__FILE__) + '/shared/pos'

describe "ARGF.pos" do
  it_behaves_like(:argf_pos, :pos)
end

describe "ARGF.pos=" do
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
  it "sets the correct position in files" do
    ARGFSpecs.file_args('file1.txt', 'file2.txt')
    linef1_1, linef1_2 =  @contents_file1.split($/).collect { |l| l+$/ }
    linef2_1, linef2_2 =  @contents_file2.split($/).collect { |l| l+$/ }

    res =[]
    ARGF.pos = linef1_1.size; res << ARGF.gets
    ARGF.pos = 0; res << ARGF.gets
    ARGF.gets # finish reading file1
    ARGF.gets
    ARGF.pos = 1; res << ARGF.gets
    ARGF.pos = linef2_1.size + linef2_2.size - 1; res << ARGF.gets
    ARGF.pos = 1000; res << ARGF.read

    res.should == [linef1_2, linef1_1, linef2_1[1..-1], linef2_2[-1,1], ""]
    
  end
  

end