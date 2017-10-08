require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/common', __FILE__)

describe "Dir.empty?" do
  ruby_version_is "2.4" do
    before :all do
      DirSpecs.create_mock_dirs
      @empty_dir = DirSpecs.mock_dir "empty_dir"
      mkdir_p @empty_dir
    end

    after :all do
      DirSpecs.delete_mock_dirs
      rm_r @empty_dir
    end

    it "returns true for empty directories" do
      result = Dir.empty? @empty_dir
      result.should be_true
    end

    it "returns false for non-empty directories" do
      result = Dir.empty? DirSpecs.mock_dir
      result.should be_false
    end

    it "returns false for a non-directory" do
      first_file = DirSpecs.mock_dir_files.first
      result = Dir.empty? "#{DirSpecs.mock_dir}/#{first_file}"
      result.should be_false
    end

    it "raises ENOENT for nonexistent directories" do
      lambda { Dir.empty?(DirSpecs.nonexistent) }.should raise_error(Errno::ENOENT)
    end
  end
end
