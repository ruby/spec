require_relative '../../spec_helper'
require 'pathname'

describe "Kernel#Pathname" do
  it "is a private method" do
    Kernel.private_instance_methods(false).should.include?(:Pathname)
  end

  it "returns same argument when called with a pathname argument" do
    path = Pathname('foo')
    new_path = Pathname(path)

    path.should.equal?(new_path)
  end
end

describe "Kernel.Pathname" do
  it "is a public method" do
    Kernel.public_methods(false).should.include?(:Pathname)
  end
end

ruby_version_is "4.0" do
  describe "Pathname" do
    it "is a core class available without require 'pathname'" do
      ruby_exe("print defined?(Pathname)", options: "--disable-gems").should == "constant"
    end

    it "provides Kernel#Pathname without require 'pathname'" do
      ruby_exe("print Pathname('a/b').class", options: "--disable-gems").should == "Pathname"
    end
  end
end
