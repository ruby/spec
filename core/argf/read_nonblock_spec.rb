require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../shared/read', __FILE__)

describe 'ARGF.read_nonblock' do
  it_behaves_like :argf_read, :read_nonblock

  before do
    @file1_name = fixture(__FILE__, 'file1.txt')
    @file2_name = fixture(__FILE__, 'file2.txt')

    @file1 = File.read(@file1_name)
    @file2 = File.read(@file2_name)

    @chunk1 = File.read(@file1_name, 4)
    @chunk2 = File.read(@file2_name, 4)
  end

  it 'reads up to the given amount of bytes' do
    argf [@file1_name] do
      @argf.read_nonblock(4).should == @chunk1
    end
  end

  describe 'when using multiple files' do
    it 'reads up to the given amount of bytes from the first file' do
      argf [@file1_name, @file2_name] do
        @argf.read_nonblock(4).should == @chunk1
      end
    end

    it 'returns an empty String when reading after having read the first file in its entirety' do
      argf [@file1_name, @file2_name] do
        @argf.read_nonblock(File.size(@file1_name)).should == @file1
        @argf.read_nonblock(4).should == ''
      end
    end
  end

  it 'reads up to the given bytes from STDIN' do
    stdin = ruby_exe('print ARGF.read_nonblock(4)', :args => "< #{@file1_name}")

    stdin.should == @chunk1
  end

  it 'reads up to the given bytes from a file when a file and STDIN are present' do
    stdin = ruby_exe("print ARGF.read_nonblock(4)", :args => "#{@file1_name} - < #{@file2_name}")

    stdin.should == @chunk1
  end
end
