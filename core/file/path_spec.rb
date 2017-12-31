require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../shared/path', __FILE__)

describe "File#path" do
  it_behaves_like :file_path, :path
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
