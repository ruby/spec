require_relative '../../spec_helper'

describe "IO#set_encoding_by_bom" do
  before :each do
    @name = tmp('io_set_encoding_by_bom.txt')
    touch(@name)
    @io = new_io(@name, 'rb')
  end

  after :each do
    @io.close unless @io.closed?
    rm_r @name
  end

  ruby_version_is "2.7" do
    it "returns the result encoding if found BOM UTF-8 sequence" do
      File.write(@name, "\u{FEFF}abc")

      @io.set_encoding_by_bom.should == Encoding::UTF_8
      @io.external_encoding.should == Encoding::UTF_8
    end

    it "returns nil if found BOM sequence not provided" do
      File.write(@name, "abc")

      @io.set_encoding_by_bom.should == nil
    end

    it 'returns exception if io not in binary mode' do
      not_binary_io = new_io(@name, 'r')

      -> { not_binary_io.set_encoding_by_bom }.should raise_error(ArgumentError, 'ASCII incompatible encoding needs binmode')
      not_binary_io.close
    end

    it 'returns exception if encoding already set' do
      @io.set_encoding("utf-8")

      -> { @io.set_encoding_by_bom }.should raise_error(ArgumentError, 'encoding is set to UTF-8 already')
    end
  end
end
