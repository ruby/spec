require_relative '../../../spec_helper'
require_relative '../spec_helper'
require 'zlib'

describe "Zlib::Deflate.deflate" do
  it "deflates some data" do
    stdout = ruby_exe(<<~'RUBY', options: '-rzlib', env: Zlib::CHILD_ENV)
      data = Array.new(10,0).pack('C*')

      zipped = Zlib::Deflate.deflate data

      puts zipped == [120, 156, 99, 96, 128, 1, 0, 0, 10, 0, 1].pack('C*')
    RUBY

    stdout.should == "true\n"
  end

  it "deflates lots of data" do
    stdout = ruby_exe(<<~'RUBY', options: '-rzlib', env: Zlib::CHILD_ENV)
      data = "\000" * 32 * 1024

      zipped = Zlib::Deflate.deflate data

      puts zipped == ([120, 156, 237, 193, 1, 1, 0, 0] +
                      [0, 128, 144, 254, 175, 238, 8, 10] +
                      Array.new(31, 0) +
                      [24, 128, 0, 0, 1]).pack('C*')
    RUBY

    stdout.should == "true\n"
  end

  it "deflates chunked data" do
    stdout = ruby_exe(<<~'RUBY', options: '-rzlib', env: Zlib::CHILD_ENV)
      random_generator = Random.new(0)
      deflated         = ''

      Zlib::Deflate.deflate(random_generator.bytes(20000)) do |chunk|
        deflated << chunk
      end

      puts deflated.length == 20016
    RUBY

    stdout.should == "true\n"
  end
end

describe "Zlib::Deflate#deflate" do
  before :each do
    @deflator = Zlib::Deflate.new
  end

  it "deflates some data" do
    stdout = ruby_exe(<<~'RUBY', options: '-rzlib', env: Zlib::CHILD_ENV)
      @deflator = Zlib::Deflate.new

      data = "\000" * 10

      zipped = @deflator.deflate data, Zlib::FINISH
      @deflator.finish

      puts zipped == [120, 156, 99, 96, 128, 1, 0, 0, 10, 0, 1].pack('C*')
    RUBY

    stdout.should == "true\n"
  end

  it "deflates lots of data" do
    stdout = ruby_exe(<<~'RUBY', options: '-rzlib', env: Zlib::CHILD_ENV)
      @deflator = Zlib::Deflate.new

      data = "\000" * 32 * 1024

      zipped = @deflator.deflate data, Zlib::FINISH
      @deflator.finish

      puts zipped == ([120, 156, 237, 193, 1, 1, 0, 0] +
                      [0, 128, 144, 254, 175, 238, 8, 10] +
                      Array.new(31, 0) +
                      [24, 128, 0, 0, 1]).pack('C*')
    RUBY

    stdout.should == "true\n"
  end

  it "has a binary encoding" do
    @deflator.deflate("").encoding.should == Encoding::BINARY
    @deflator.finish.encoding.should == Encoding::BINARY
  end
end

describe "Zlib::Deflate#deflate" do

  before :each do
    @deflator         = Zlib::Deflate.new
    @random_generator = Random.new(0)
    @original         = ''
    @chunks           = []
  end

  describe "without break" do

    before do
      2.times do
        @input = @random_generator.bytes(20000)
        @original << @input
        @deflator.deflate(@input) do |chunk|
          @chunks << chunk
        end
      end
    end

    it "deflates chunked data" do
      @deflator.finish
      @chunks.map { |chunk| chunk.length }.should == [16384, 16384]
    end

    it "deflates chunked data with final chunk" do
      stdout = ruby_exe(<<~'RUBY', options: '-rzlib', env: Zlib::CHILD_ENV)
        @deflator         = Zlib::Deflate.new
        @random_generator = Random.new(0)
        @original         = ''
        @chunks           = []

        2.times do
          @input = @random_generator.bytes(20000)
          @original << @input
          @deflator.deflate(@input) do |chunk|
            @chunks << chunk
          end
        end

        final = @deflator.finish
        puts final.length == 7253
      RUBY

      stdout.should == "true\n"
    end

    it "deflates chunked data without errors" do
      final = @deflator.finish
      @chunks << final
      @original.should == Zlib.inflate(@chunks.join)
    end

  end

  describe "with break" do
    before :each do
      @input = @random_generator.bytes(20000)
      @deflator.deflate(@input) do |chunk|
        @chunks << chunk
        break
      end
    end

    it "deflates only first chunk" do
      @deflator.finish
      @chunks.map { |chunk| chunk.length }.should == [16384]
    end

    it "deflates chunked data with final chunk" do
      stdout = ruby_exe(<<~'RUBY', options: '-rzlib', env: Zlib::CHILD_ENV)
        @deflator         = Zlib::Deflate.new
        @random_generator = Random.new(0)
        @original         = ''
        @chunks           = []

        @input = @random_generator.bytes(20000)
        @deflator.deflate(@input) do |chunk|
          @chunks << chunk
          break
        end

        final = @deflator.finish
        puts final.length == 3632
      RUBY

      stdout.should == "true\n"
    end

    it "deflates chunked data without errors" do
      final = @deflator.finish
      @chunks << final
      @input.should == Zlib.inflate(@chunks.join)
    end

  end
end
