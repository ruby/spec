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

  it "returns the string argument without any change" do
    File.path("abc").should == "abc"
    File.path("./abc").should == "./abc"
    File.path("../abc").should == "../abc"
    File.path("/./a/../bc").should == "/./a/../bc"
  end

  it "returns path for File argument" do
    File.open(@name, "w") do |f|
      File.path(f).should == @name
    end
  end

  it "returns path for Pathname argument" do
    require "pathname"
    File.path(Pathname.new(@name)).should == @name
  end

  it "calls #to_path for non-string argument and returns result" do
    path = mock("path")
    path.should_receive(:to_path).and_return("abc")
    File.path(path).should == "abc"
  end
end
