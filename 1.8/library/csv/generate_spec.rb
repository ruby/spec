require File.dirname(__FILE__) + '/../../spec_helper'
require 'csv'
require 'tempfile'

describe "CSV.generate" do
  
  before :each do
    @outfile_name = File.join(Dir.tmpdir, "generate_test_#{$$}.csv")  
  end
 
  it "should create a BasicWriter" do
    writer = CSV::generate(@outfile_name)
    writer.should be_kind_of(CSV::BasicWriter)
    writer.close
  end

  it "should create a BasicWriter with ; as the seperator" do
    writer = CSV::generate(@outfile_name)
    writer.should be_kind_of(CSV::BasicWriter)
    writer.close
  end
  
  it "should create a BasicWriter inside the block" do
    CSV::generate(@outfile_name) do |writer|
      writer.should be_kind_of(CSV::BasicWriter)
    end
  end

  it "should create a BasicWriter with ; as the seperator inside the block" do
    CSV::generate(@outfile_name, ?;) do |writer|
      writer.should be_kind_of(CSV::BasicWriter)
    end
  end
   
  after :each do
    FileUtils.rm(@outfile_name) 
  end

end
