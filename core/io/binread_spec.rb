# -*- encoding: utf-8 -*-
require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

ruby_version_is "1.9" do
  describe "IO.binread" do
    before :each do
      @fname = tmp('io_read.txt')
      @contents = "1234567890"
      touch(@fname) { |f| f.write @contents }
    end

    after :each do
      rm_r @fname
    end

    it "reads the contents of a file" do
      IO.binread(@fname).should == @contents
    end

    it "reads the contents of a file up to a certain size when specified" do
      IO.binread(@fname, 5).should == @contents.slice(0..4)
    end

    it "reads the contents of a file from an offset of a specific size when specified" do
      IO.binread(@fname, 5, 3).should == @contents.slice(3, 5)
    end

    it "needs to be reviewed for spec completeness"
  end
end
