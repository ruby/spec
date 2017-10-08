require File.expand_path('../../spec_helper', __dir__)
require File.expand_path('fixtures/common', __dir__)

describe 'Dir.empty?' do
  ruby_version_is "2.4" do
    it 'Report false when the directory has a file(s)' do
      (Dir.empty? __dir__).should be_false
    end

    it 'Report false when path is not a folder' do
      (Dir.empty? __FILE__).should be_false
    end

    it 'Report true when the dir has no files' do
      subdir = File.join(tmp("new_empty_folder_99"))
      Dir.mkdir(subdir)
      (Dir.empty? subdir).should be_true
      Dir.rmdir(subdir)
    end

    it 'Raise Errno::ENOENT on non-existing directory' do
      lambda do
        Dir.empty? DirSpecs.nonexistent
      end.should raise_error(Errno::ENOENT)
    end
  end
end
