require_relative '../../spec_helper'
require 'pathname'

describe "Kernel#Pathname" do
  it "is a public method" do
    Kernel.public_methods.should include(:Pathname)
  end

  ruby_version_is ''...'2.7' do
    it "returns a new pathname when called with a pathname argument" do
      path = Pathname('foo')
      new_path = Pathname(path)

      (path.object_id == new_path.object_id).should be_false
    end
  end

  ruby_version_is '2.7' do
    it "returns same argument when called with a pathname argument" do
      path = Pathname('foo')
      new_path = Pathname(path)

      (path.object_id == new_path.object_id).should be_true
    end
  end
end
