require 'zlib'
require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Zlib::Inflate#inflate' do

  before :each do
    @inflator = Zlib::Inflate.new
  end

  it 'inflates some data' do
    data = "x\234c`\200\001\000\000\n\000\001"

    unzipped = @inflator.inflate data
    @inflator.finish

    unzipped.should == "\000" * 10
  end

  it 'inflates lots of data' do
    data = "x\234\355\301\001\001\000\000\000\200\220\376\257\356\b\n#{"\000" * 31}\030\200\000\000\001"

    unzipped = @inflator.inflate data
    @inflator.finish

    unzipped.should == "\000" * 32 * 1024
  end

  it 'works in pass-through mode, once finished' do
    data = "x\234c`\200\001\000\000\n\000\001"

    unzipped = @inflator.inflate data
    @inflator.finish  # this is a precondition

    out = @inflator.inflate('uncompressed_data')
    out << @inflator.finish
    out.should == 'uncompressed_data'

    @inflator << ('uncompressed_data') << nil
    @inflator.finish.should == 'uncompressed_data'
  end

end

describe 'Zlib::Inflate::inflate' do

  it 'inflates some data' do
    data = "x\234c`\200\001\000\000\n\000\001"

    unzipped = Zlib::Inflate.inflate data

    unzipped.should == "\000" * 10
  end

  it 'inflates lots of data' do
    data = "x\234\355\301\001\001\000\000\000\200\220\376\257\356\b\n#{"\000" * 31}\030\200\000\000\001"

    zipped = Zlib::Inflate.inflate data

    zipped.should == "\000" * 32 * 1024
  end

end

