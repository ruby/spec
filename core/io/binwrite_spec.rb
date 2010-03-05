require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../shared/write', __FILE__)

ruby_version_is "1.9" do
  describe "IO.binwrite" do
    it_behaves_like :io_write_sing, :binwrite

    it "doesn't skip $offset bytes if given a Fixnum offset" do
      File.open(@file,'w'){|f| f << @original}
      IO.binwrite(@file, @data, 2)
      IO.read(@file).should == @original + @data
    end

    it "appends to the file if given an offset of 0" do
      File.open(@file,'w'){|f| f << @original}
      IO.binwrite(@file, @data, 0)
      IO.read(@file).should == @original + @data
    end

    it "doesn't pad with null bytes if $offset exceeds the original file's length" do
      File.open(@file,'w'){|f| f << 'date her'}
      IO.binwrite(@file, @data, 10)
      IO.read(@file).should ==  "date her" + @data
    end

    it "returns the number of bytes written if $offset > file length" do
      IO.binwrite(@file, @data, 2).should == @data.size
      File.size(@file).should == @data.size
    end

    it "doesn't insert $offset leading null bytes for non-existent files" do
      IO.binwrite(@file, @data, 2)
      IO.read(@file).should == @data
    end
  end
end
