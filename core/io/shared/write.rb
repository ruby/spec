require File.expand_path('../../fixtures/classes', __FILE__)

describe :io_write, :shared => true do
  before :each do
    @filename = tmp("IO_syswrite_file") + $$.to_s
    File.open(@filename, "w") do |file|
      file.send(@method, "012345678901234567890123456789")
    end
    @file = File.open(@filename, "r+")
    @readonly_file = File.open(@filename)
  end

  after :each do
    @file.close
    @readonly_file.close
    rm_r @filename
  end

  it "coerces the argument to a string using to_s" do
    (obj = mock('test')).should_receive(:to_s).and_return('a string')
    @file.send(@method, obj)
  end

  it "checks if the file is writable if writing more than zero bytes" do
    lambda { @readonly_file.send(@method, "abcde") }.should raise_error(IOError)
  end

  it "returns the number of bytes written" do
    written = @file.send(@method, "abcde")
    written.should == 5
  end

  it "invokes to_s on non-String argument" do
    data = "abcdefgh9876"
    (obj = mock(data)).should_receive(:to_s).and_return(data)
    @file.send(@method, obj)
    @file.seek(0)
    @file.read(data.size).should == data
  end

  it "writes all of the string's bytes without buffering if mode is sync" do
    @file.sync = true
    written = @file.send(@method, "abcde")
    written.should == 5
    File.open(@filename) do |file|
      file.read(10).should == "abcde56789"
    end
  end

  it "does not warn if called after IO#read" do
    @file.read(5)
    lambda { @file.send(@method, "fghij") }.should_not complain
  end

  it "writes to the current position after IO#read" do
    @file.read(5)
    @file.send(@method, "abcd")
    @file.rewind
    @file.read.should == "01234abcd901234567890123456789"
  end

  it "advances the file position by the count of given bytes" do
    @file.send(@method, "abcde")
    @file.read(10).should == "5678901234"
  end

  it "raises IOError on closed stream" do
    lambda { IOSpecs.closed_file.send(@method, "hello") }.should raise_error(IOError)
  end
end

describe :io_write_sing, :shared => true do
  before :each do
    @file = tmp('IO.write')
    @data = "string"
    @original = "original"
  end

  after :each do
    File.delete(@file) if File.exists?(@file)
  end

  it "writes the given string to the given file" do
    IO.send(@method, @file, @data)
    IO.read(@file).should == @data
  end

  it "truncates existing files before writing to them" do
    File.open(@file,'w'){|f| f << @original}
    IO.send(@method, @file, @data)
    IO.read(@file).should == @data
  end

  it "creates the target file if necessary" do
    File.exists?(@file).should be_false
    IO.send(@method, @file, @data)
    IO.read(@file).should == @data
    File.exists?(@file).should be_true
  end

  it "raises Errno::EACCES if the OS denies write permission" do
    lambda { IO.send(@method, '/glark', @data) }.should raise_error(Errno::EACCES)
  end

  it "raises Errno::ENOENT if the path's parent doesn't exist" do
    lambda { IO.send(@method, tmp('ZzZ/glark'),@data) }.should raise_error(Errno::ENOENT)
  end

  it "raises Errno::EISDIR if the path is a directory" do
    lambda { IO.send(@method, tmp(''),@data) }.should raise_error(Errno::EISDIR)
  end

  it "returns the number of bytes written" do
    @data = (200..400).map{|o| o.chr('utf-8')}.join
    IO.send(@method, @file, @data).should == @data.bytesize
    File.size(@file).should == @data.bytesize
  end

  it "calls #to_path on its first argument if said argument is not a string" do
    name = mock("file")
    name.should_receive(:to_path).and_return(@file)
    IO.send(@method, name, @data)
  end

  it "calls #to_str on its first argument if said argument is not a string and can't to_path" do
    name = mock("file")
    name.should_receive(:to_str).and_return(@file)
    IO.send(@method, name, @data)
  end

   it "calls #to_s on its second argument if said argument is not a string" do
    str = mock("str")
    str.should_receive(:to_s).and_return(@data)
    IO.send(@method, @file, str)
   end
end
