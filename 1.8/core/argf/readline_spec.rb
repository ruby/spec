require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/shared/gets'

describe "ARGF.readline" do
  it_behaves_like :argf_gets, :readline
end

describe "ARGF.gets" do
  it_behaves_like :argf_gets_inplace_edit, :readline
end

describe "ARGF.gets" do
  before :each do
    @file1_name = fixture __FILE__, "file1.txt"
    @file2_name = fixture __FILE__, "file2.txt"

    @file1 = File.readlines @file1_name
    @file2 = File.readlines @file2_name
  end

  after :each do
    ARGF.close
  end

  it "raises an EOFError when reaching end of files" do
    argv [@file1_name, @file2_name] do
      lambda {
        while line = ARGF.readline; end
      }.should raise_error(EOFError)
    end
  end
end
