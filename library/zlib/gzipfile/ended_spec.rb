require File.expand_path('../../../../spec_helper', __FILE__)
require 'stringio'
require 'zlib'

describe 'Zlib::GzipFile#ended?' do
  it 'returns the closed status' do
    io = StringIO.new
    Zlib::GzipWriter.wrap io do |gzio|
      gzio.ended?.should == false

      gzio.close

      gzio.ended?.should == true
    end
  end
end

