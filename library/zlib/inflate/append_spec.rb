require File.dirname(__FILE__) + '/../../../spec_helper'
require 'zlib'

describe 'Zlib::Inflate#<<' do
  before :all do
    @foo_deflated = "x\234K\313\317\a\000\002\202\001E"
  end

  before :each do
    @z = Zlib::Inflate.new
  end

  after :each do
    @z.close unless @z.closed?
  end

  it 'appends data to the input stream' do
    @z << @foo_deflated
    @z.finish.should == 'foo'
  end

  it 'treats nil argument as the end of compressed data' do
    @z = Zlib::Inflate.new
    @z << @foo_deflated << nil
    @z.finish.should == 'foo'
  end

  it 'just passes through the data after nil argument' do
    @z = Zlib::Inflate.new
    @z << @foo_deflated << nil
    @z << "-after_nil_data"
    @z.finish.should == 'foo-after_nil_data'
  end

end
