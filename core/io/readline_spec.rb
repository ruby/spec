# -*- encoding: utf-8 -*-
require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'

def _open(*arg, &block)
  fn = arg[0]
  mode = arg[1]
  mode = mode ? mode + ':UTF-8' : 'r:UTF-8' if Encoding
  File.open(fn, mode, &block)
end

describe "IO#readline" do

  it "returns the next line on the stream" do
    testfile = File.dirname(__FILE__) + '/fixtures/gets.txt'
    f = _open(testfile, 'r') do |f|
      f.readline.should == "Voici la ligne une.\n"
      f.readline.should == "Qui è la linea due.\n"
    end
  end

  it "goes back to first position after a rewind" do
    testfile = File.dirname(__FILE__) + '/fixtures/gets.txt'
    f = _open(testfile, 'r') do |f|
      f.readline.should == "Voici la ligne une.\n"
      f.rewind
      f.readline.should == "Voici la ligne une.\n"
    end
  end

  it "is modified by the cursor position" do
    testfile = File.dirname(__FILE__) + '/fixtures/gets.txt'
    f = _open(testfile, 'r') do |f|
      f.seek(1)
      f.readline.should == "oici la ligne une.\n"
    end
  end

  it "raises EOFError on end of stream" do
    testfile = File.dirname(__FILE__) + '/fixtures/gets.txt'
    _open(testfile, 'r') do |f|
      lambda { while true; f.readline; end }.should raise_error(EOFError)
    end

  end

  it "raises IOError on closed stream" do
    lambda { IOSpecs.closed_file.readline }.should raise_error(IOError)
  end

  it "assigns the returned line to $_" do
    _open(IOSpecs.gets_fixtures, 'r') do |f|
      IOSpecs.lines.each do |line|
        f.readline
        $_.should == line
      end
    end
  end
end
