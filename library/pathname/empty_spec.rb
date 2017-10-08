require File.expand_path('../../spec_helper', __dir__)
require 'pathname'

describe "Pathname#empty?" do
  ruby_version_is "2.4" do
    it 'returns true when file is not empty' do
      (Pathname.new(__FILE__).empty?).should be_false
    end

    it 'returns false when the directory is not empty' do
      (Pathname.new(__dir__).empty?).should be_false
    end

    it 'return true when file is empty' do
      file = tmp('new_file_path_name.txt')
      touch(file)
      (Pathname.new(file).empty?).should be_true
      File.delete(file)
    end

    it 'returns true when directory is empty' do
      dir = File.join(tmp("new_directory_path_name"))
      Dir.mkdir(dir)
      (Pathname.new(dir).empty?).should be_true
      Dir.rmdir(dir)
    end
  end
end
