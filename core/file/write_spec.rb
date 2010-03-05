require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is "1.9" do
  describe "File.write" do
    before :each do
      @file = tmp('File.write')
      @data = "string"
      @original = "original"
    end

  after :each do
    File.delete(@file) if File.exists?(@file)
  end

   it "writes the given string to the given file" do
     File.write(@file, @data)
     File.read(@file).should == @data
   end

   it "truncates existing files before writing to them" do
     File.open(@file,'w'){|f| f << @original}
     File.write(@file, @data)
     File.read(@file).should == @data
   end

   it "creates the target file if necessary" do
     File.exists?(@file).should be_false
     File.write(@file, @data)
     File.read(@file).should == @data
     File.exists?(@file).should be_true
   end

   it "raises Errno::EACCES if the OS denies write permission" do
     lambda { File.write('/glark',@data) }.should raise_error(Errno::EACCES)
   end

   it "raises Errno::ENOENT if the path's parent doesn't exist" do
     lambda { File.write(tmp('ZzZ/glark'),@data) }.should raise_error(Errno::ENOENT)
   end

   it "raises Errno::EISDIR if the path is a directory" do
     lambda { File.write(tmp(''),@data) }.should raise_error(Errno::EISDIR)
   end

   it "returns the number of bytes written" do
     @data = (200..400).map{|o| o.chr('utf-8')}.join
     File.write(@file, @data).should == @data.bytesize
   end

   it "skips $offset bytes if given a Fixnum offset" do
     File.open(@file,'w'){|f| f << @original}
     File.write(@file, @data, 2)
     File.read(@file).should == @original[0..1] + @data
   end

   it "writes from the beginning of the file if given an offset of 0" do
     File.open(@file,'w'){|f| f << @original}
     File.write(@file, @data, 0)
     File.read(@file).should == @data + @original[-(@original.size - @data.size)..-1]
   end

   it "raises Errno::EINVAL if given a negative offset" do
     lambda { File.write(@file, @data, -2) }.should raise_error(Errno::EINVAL)
   end

   it "returns the number of bytes written when an offset is supplied" do
     File.open(@file,'w'){|f| f << 'original'}
     File.write(@file, @data, 2).should == @data.size
   end

   it "pads with null bytes if $offset exceeds the original file's length" do
     File.open(@file,'w'){|f| f << 'date her'}
     File.write(@file, @data, 10)
     File.read(@file).should ==  "date her\u0000\u0000" + @data
   end

   it "returns the number of bytes written (excluding that of any prepended nulls if $offset > file length)" do
     File.write(@file, @data, 2).should == @data.size
     File.size(@file).should == @data.size + 2
   end

   it "inserts $offset leading null bytes if the file doesn't already exist" do
     File.write(@file, @data, 2)
     File.read(@file).should == "\u0000\u0000" + @data
   end

   it "calls #to_path on its first argument if said argument is not a string" do
      name = mock("file")
      name.should_receive(:to_path).and_return(@file)
      File.write(name, @data)
   end

   it "calls #to_str on its first argument if said argument is not a string and can't to_path" do
      name = mock("file")
      name.should_receive(:to_str).and_return(@file)
      File.write(name, @data)
   end

   it "calls #to_s on its second argument if said argument is not a string" do
      str = mock("str")
      str.should_receive(:to_s).and_return(@data)
      File.write(@file, str)
   end
  end
end
