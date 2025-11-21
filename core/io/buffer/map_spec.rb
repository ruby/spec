require_relative '../../../spec_helper'

describe "IO::Buffer.map" do
  after :each do
    @buffer&.free
    @buffer = nil
    @file&.close
    @file = nil
  end

  def open_fixture
    File.open("#{__dir__}/../fixtures/read_text.txt", "r+")
  end

  it "creates a new buffer mapped from a file" do
    @file = open_fixture
    @buffer = IO::Buffer.map(@file)

    @buffer.size.should == 9
    @buffer.get_string.force_encoding(Encoding::UTF_8).should == "abcâdef\n"
  end

  it "allows to close the file after creating buffer, retaining mapping" do
    file = open_fixture
    @buffer = IO::Buffer.map(file)
    file.close

    @buffer.get_string.force_encoding(Encoding::UTF_8).should == "abcâdef\n"
  end

  ruby_version_is ""..."3.3" do
    it "creates a buffer with default state and expected flags" do
      @file = open_fixture
      @buffer = IO::Buffer.map(@file)

      @buffer.should_not.internal?
      @buffer.should.mapped?
      @buffer.should.external?

      @buffer.should_not.empty?
      @buffer.should_not.null?

      @buffer.should.shared?
      @buffer.should_not.readonly?

      @buffer.should_not.locked?
      @buffer.should.valid?
    end
  end

  ruby_version_is "3.3" do
    it "creates a buffer with default state and expected flags" do
      @file = open_fixture
      @buffer = IO::Buffer.map(@file)

      @buffer.should_not.internal?
      @buffer.should.mapped?
      @buffer.should.external?

      @buffer.should_not.empty?
      @buffer.should_not.null?

      @buffer.should.shared?
      @buffer.should_not.private?
      @buffer.should_not.readonly?

      @buffer.should_not.locked?
      @buffer.should.valid?
    end
  end

  context "with an empty file" do
    ruby_version_is ""..."4.0" do
      platform_is_not :windows do
        it "raises Errno::EINVAL" do
          @file = File.open("#{__dir__}/../fixtures/empty.txt", "r+")
          -> { IO::Buffer.map(@file) }.should raise_error(Errno::EINVAL)
        end
      end

      platform_is :windows do
        it "raises Errno::ENOTTY" do
          @file = File.open("#{__dir__}/../fixtures/empty.txt", "r+")
          -> { IO::Buffer.map(@file) }.should raise_error(Errno::ENOTTY)
        end
      end
    end

    ruby_version_is "4.0" do
      it "raises ArgumentError" do
        @file = File.open("#{__dir__}/../fixtures/empty.txt", "r+")
        -> { IO::Buffer.map(@file) }.should raise_error(ArgumentError, "Invalid negative or zero file size!")
      end
    end
  end

  context "with size argument" do
    it "limits the buffer to the specified size in bytes, starting from the start of the file" do
      @file = open_fixture
      @buffer = IO::Buffer.map(@file, 4)

      @buffer.size.should == 4
      @buffer.get_string.force_encoding(Encoding::UTF_8).should == "abc\xC3"
    end

    it "maps the whole file if size is nil" do
      @file = open_fixture
      @buffer = IO::Buffer.map(@file, nil)

      @buffer.size.should == 9
    end

    ruby_version_is ""..."4.0" do
      platform_is_not :windows do
        it "raises Errno::EINVAL if size is 0" do
          @file = open_fixture
          -> { IO::Buffer.map(@file, 0) }.should raise_error(Errno::EINVAL)
        end
      end
    end

    ruby_version_is "4.0" do
      it "raises ArgumentError if size is 0" do
        @file = open_fixture
        -> { IO::Buffer.map(@file, 0) }.should raise_error(ArgumentError, "Size can't be zero!")
      end
    end

    it "raises TypeError if size is not an Integer or nil" do
      @file = open_fixture
      -> { IO::Buffer.map(@file, "10") }.should raise_error(TypeError, "not an Integer")
      -> { IO::Buffer.map(@file, 10.0) }.should raise_error(TypeError, "not an Integer")
    end

    it "raises ArgumentError if size is negative" do
      @file = open_fixture
      -> { IO::Buffer.map(@file, -1) }.should raise_error(ArgumentError, "Size can't be negative!")
    end

    ruby_version_is ""..."4.0" do
      it "raises Errno::EINVAL if size is larger than file size" do
        @file = open_fixture
        -> { IO::Buffer.map(@file, 8192) }.should raise_error(Errno::EINVAL)
      end
    end

    ruby_version_is "4.0" do
      it "raises ArgumentError if size is larger than file size" do
        @file = open_fixture
        -> { IO::Buffer.map(@file, 8192) }.should raise_error(ArgumentError, "Size can't be larger than file size!")
      end
    end
  end

  context "with size and offset arguments" do
    platform_is :linux do
      context "if offset is a multiple of page size" do
        it "maps the specified length starting from the offset" do
          @file = File.open("README.md", "r+")
          @buffer = IO::Buffer.map(@file, 14, 65536)

          @buffer.size.should == 14
          # @buffer.get_string(0, 14).force_encoding(Encoding::UTF_8).should == "# Ruby Spec"
        end

        # A second mapping just doesn't work?
        it "maps the rest of the file if size is nil" do
          @file = File.open("#{__dir__}/fixtures/big_file.txt", "r+")
          @buffer = IO::Buffer.map(@file, nil, IO::Buffer::PAGE_SIZE)

          @buffer.size.should == 5895 # BUG: why is this the total size?
          @buffer.get_string(0, 1).force_encoding(Encoding::UTF_8).should == "-"
        end
      end

      it "raises Errno::EINVAL if offset is not a multiple of page size" do
        @file = open_fixture
        -> { IO::Buffer.map(@file, 4, IO::Buffer::PAGE_SIZE / 2) }.should raise_error(Errno::EINVAL)
      end
    end

    it "maps the file from the start if offset is 0" do
      @file = open_fixture
      @buffer = IO::Buffer.map(@file, 4, 0)

      @buffer.size.should == 4
      @buffer.get_string.force_encoding(Encoding::UTF_8).should == "abc\xC3"
    end

    it "raises TypeError if offset is not convertible to Integer" do
      @file = open_fixture
      -> { IO::Buffer.map(@file, 4, "4096") }.should raise_error(TypeError, "no implicit conversion of String into Integer")
      -> { IO::Buffer.map(@file, 4, nil) }.should raise_error(TypeError, "no implicit conversion from nil to integer")
    end

    it "raises Errno::EINVAL if offset is not an allowed value" do
      @file = open_fixture
      -> { IO::Buffer.map(@file, 4, 3) }.should raise_error(Errno::EINVAL)
    end

    it "raises Errno::EINVAL if offset is negative" do
      @file = open_fixture
      -> { IO::Buffer.map(@file, 4, -1) }.should raise_error(Errno::EINVAL)
    end
  end
end
