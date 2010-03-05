require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)
require File.expand_path('../shared/write', __FILE__)

describe "IO#write on a file" do
  before :each do
    @filename = tmp("IO_syswrite_file") + $$.to_s
    File.open(@filename, "w") do |file|
      file.write("012345678901234567890123456789")
    end
    @file = File.open(@filename, "r+")
    @readonly_file = File.open(@filename)
  end

  after :each do
    @file.close
    @readonly_file.close
    rm_r @filename
  end

  # TODO: impl detail? discuss this with matz. This spec is useless. - rdavis
  # I agree. I've marked it not compliant on macruby, as we don't buffer input. -pthomson
  not_compliant_on :macruby do
    it "writes all of the string's bytes but buffers them" do
      written = @file.write("abcde")
      written.should == 5
      File.open(@filename) do |file|
        file.read.should == "012345678901234567890123456789"
        @file.fsync
        file.rewind
        file.read.should == "abcde5678901234567890123456789"
      end
    end
  end

  it "does not check if the file is writable if writing zero bytes" do
    lambda { @readonly_file.write("") }.should_not raise_error
  end

  it "returns a length of 0 when writing a blank string" do
    @file.write('').should == 0
  end
end

describe "IO#write" do
  it_behaves_like :io_write, :write
end

ruby_version_is "1.9" do
  describe "IO.write" do
    before :each do
      @file = tmp('IO.write')
      @data = "string"
      @original = "original"
    end

  after :each do
    File.delete(@file) if File.exists?(@file)
  end

   it "writes the given string to the given file" do
     IO.write(@file, @data)
     IO.read(@file).should == @data
   end

   it "truncates existing files before writing to them" do
     File.open(@file,'w'){|f| f << @original}
     IO.write(@file, @data)
     IO.read(@file).should == @data
   end

   it "creates the target file if necessary" do
     File.exists?(@file).should be_false
     IO.write(@file, @data)
     IO.read(@file).should == @data
     File.exists?(@file).should be_true
   end

   it "raises Errno::EACCES if the OS denies write permission" do
     lambda { IO.write('/glark',@data) }.should raise_error(Errno::EACCES)
   end

   it "raises Errno::ENOENT if the path's parent doesn't exist" do
     lambda { IO.write(tmp('ZzZ/glark'),@data) }.should raise_error(Errno::ENOENT)
   end

   it "raises Errno::EISDIR if the path is a directory" do
     lambda { IO.write(tmp(''),@data) }.should raise_error(Errno::EISDIR)
   end

   it "returns the number of bytes written" do
     @data = (200..400).map{|o| o.chr('utf-8')}.join
     IO.write(@file, @data).should == @data.bytesize
   end

   it "skips $offset bytes if given a Fixnum offset" do
     File.open(@file,'w'){|f| f << @original}
     IO.write(@file, @data, 2)
     IO.read(@file).should == @original[0..1] + @data
   end

   it "writes from the beginning of the file if given an offset of 0" do
     File.open(@file,'w'){|f| f << @original}
     IO.write(@file, @data, 0)
     IO.read(@file).should == @data + @original[-(@original.size - @data.size)..-1]
   end

   it "raises Errno::EINVAL if given a negative offset" do
     lambda { IO.write(@file, @data, -2) }.should raise_error(Errno::EINVAL)
   end

   it "returns the number of bytes written when an offset is supplied" do
     File.open(@file,'w'){|f| f << 'original'}
     IO.write(@file, @data, 2).should == @data.size
   end

   it "pads with null bytes if $offset exceeds the original file's length" do
     File.open(@file,'w'){|f| f << 'date her'}
     IO.write(@file, @data, 10)
     IO.read(@file).should ==  "date her\u0000\u0000" + @data
   end

   it "returns the number of bytes written (excluding that of any prepended nulls if $offset > file length)" do
     IO.write(@file, @data, 2).should == @data.size
     File.size(@file).should == @data.size + 2
   end

   it "inserts $offset leading null bytes if the file doesn't already exist" do
     IO.write(@file, @data, 2)
     IO.read(@file).should == "\u0000\u0000" + @data
   end

   it "calls #to_path on its first argument if said argument is not a string" do
      name = mock("file")
      name.should_receive(:to_path).and_return(@file)
      IO.write(name, @data)
   end

   it "calls #to_str on its first argument if said argument is not a string and can't to_path" do
      name = mock("file")
      name.should_receive(:to_str).and_return(@file)
      IO.write(name, @data)
   end

   it "calls #to_s on its second argument if said argument is not a string" do
      str = mock("str")
      str.should_receive(:to_s).and_return(@data)
      IO.write(@file, str)
   end
  end
end
