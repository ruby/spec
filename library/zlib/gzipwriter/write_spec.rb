require_relative '../../../spec_helper'
require_relative '../spec_helper'
require 'stringio'
require 'zlib'

describe "Zlib::GzipWriter#write" do
  before :each do
    @data = '12345abcde'
    @zip = [31, 139, 8, 0, 44, 220, 209, 71, 0, 3, 51, 52, 50, 54, 49, 77,
            76, 74, 78, 73, 5, 0, 157, 5, 0, 36, 10, 0, 0, 0].pack('C*')
    @io = StringIO.new "".b
  end

  it "writes some compressed data" do
    opts = {options: '-rzlib -rstringio', env: Zlib::CHILD_ENV}
    stdout = ruby_exe(<<~'RUBY', opts)
      @data = '12345abcde'
      @zip = [31, 139, 8, 0, 44, 220, 209, 71, 0, 3, 51, 52, 50, 54, 49, 77,
              76, 74, 78, 73, 5, 0, 157, 5, 0, 36, 10, 0, 0, 0].pack('C*')
      @io = StringIO.new "".b

      Zlib::GzipWriter.wrap @io do |gzio|
        gzio.write @data
      end

      # skip gzip header for now
      puts @io.string.unpack('C*')[10..-1] == @zip.unpack('C*')[10..-1]
    RUBY

    stdout.should == "true\n"
  end

  it "returns the number of bytes in the input" do
    Zlib::GzipWriter.wrap @io do |gzio|
      gzio.write(@data).should == @data.size
    end
  end

  it "handles inputs of 2^23 bytes" do
    opts = {options: '-rzlib -rstringio', env: Zlib::CHILD_ENV}
    stdout = ruby_exe(<<~'RUBY', opts)
      @data = '12345abcde'
      @zip = [31, 139, 8, 0, 44, 220, 209, 71, 0, 3, 51, 52, 50, 54, 49, 77,
              76, 74, 78, 73, 5, 0, 157, 5, 0, 36, 10, 0, 0, 0].pack('C*')
      @io = StringIO.new "".b

      input = '.'.b * (2 ** 23)

      Zlib::GzipWriter.wrap @io do |gzio|
        gzio.write input
      end
      puts @io.string.size == 8176
    RUBY

    stdout.should == "true\n"
  end
end
