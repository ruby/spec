require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../shared/path', __FILE__)

describe "File#path" do
  it_behaves_like :file_path, :path

  ruby_version_is "2.5" do
    platform_is :linux do
      if defined?(File::TMPFILE)
        before :each do
          @dir = tmp("tmpfilespec")
          mkdir_p @dir
        end

        after :each do
          rm_r @dir
        end

        it "raises IOError if file was opened with File::TMPFILE" do
          begin
            File.open(@dir, File::RDWR | File::TMPFILE) do |f|
              -> { f.path }.should raise_error(IOError)
            end
          rescue Errno::EOPNOTSUPP
            # EOPNOTSUPP: no support from the filesystem
            1.should == 1
          end
        end
      end
    end
  end
end

describe "File.path" do
  before :each do
    @name = tmp("file_path")
  end

  after :each do
    rm_r @name
  end

  it "returns the full path for the given file" do
    File.path(@name).should == @name
  end
end
