# -*- encoding: utf-8 -*-
require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'

describe "IO#readlines" do
  before :each do
    @io = File.open fixture(__FILE__, "readlines.txt")
  end

  after :each do
    @io.close unless @io.closed?
  end

  it "raises an IOError if the stream is closed" do
    @io.close
    lambda { @io.readlines }.should raise_error(IOError)
  end

  describe "when passed no arguments" do
    before :each do
      @sep, $/ = $/, " "
    end

    after :each do
      $/ = @sep
    end

    it "returns an Array containing lines based on $/" do
      @io.readlines.should == ["Voici ", "la ", "ligne ", "une.\nQui ", "\303\250 ",
        "la ", "linea ", "due.\nAqu\303\255 ", "est\303\241 ", "la ", "l\303\255nea ",
        "tres.\nIst ", "hier ", "Linie ", "vier.\nEst\303\241 ", "aqui ", "a ",
        "linha ", "cinco.\nHere ", "is ", "line ", "six.\n"]
    end
  end

  describe "when passed no arguments" do
    it "updates self's position" do
      @io.readlines
      @io.pos.should eql(134)
    end

    it "updates self's lineno based on the number of lines read" do
      @io.readlines
      @io.lineno.should eql(6)
    end

    it "does not change $_" do
      $_ = "test"
      @io.readlines
      $_.should == "test"
    end

    it "returns an empty Array when self is at the end" do
      @io.pos = 134
      @io.readlines.should == []
    end
  end

  describe "when passed nil" do
    it "returns the remaining content as one line starting at the current position" do
      @io.pos = 5
      @io.readlines(nil).should == [" la ligne une.\nQui \303\250 la linea due.\n" +
        "Aqu\303\255 est\303\241 la l\303\255nea tres.\n" +
        "Ist hier Linie vier.\nEst\303\241 aqui a linha cinco.\nHere is line six.\n"]
    end
  end

  describe "when passed a separator" do
    it "returns an Array containing lines based on the separator" do
      @io.readlines("r").should == [
        "Voici la ligne une.\nQui \303\250 la linea due.\nAqu\303\255 est\303\241 la l\303\255nea tr",
        "es.\nIst hier",
        " Linie vier",
        ".\nEst\303\241 aqui a linha cinco.\nHer",
        "e is line six.\n"]
    end

    it "returns an empty Array when self is at the end" do
      @io.pos = 134
      @io.readlines.should == []
    end

    it "updates self's lineno based on the number of lines read" do
      @io.readlines("r")
      @io.lineno.should eql(5)
    end

    it "updates self's position based on the number of characters read" do
      @io.readlines("r")
      @io.pos.should eql(134)
    end

    it "does not change $_" do
      $_ = "test"
      @io.readlines("r")
      $_.should == "test"
    end

    it "tries to convert the passed separator to a String using #to_str" do
      obj = mock('to_str')
      obj.stub!(:to_str).and_return("r")
      @io.readlines(obj).should == [
        "Voici la ligne une.\nQui \303\250 la linea due.\nAqu\303\255 est\303\241 la l\303\255nea tr",
        "es.\nIst hier",
        " Linie vier",
        ".\nEst\303\241 aqui a linha cinco.\nHer",
        "e is line six.\n"]
    end
  end
end

describe "IO#readlines when passed an empty String" do
  before(:each) do
    @io = File.open fixture(__FILE__, "paragraphs.txt")
  end

  after(:each) do
    @io.close unless @io.closed?
  end

  it "returns an Array containing all paragraphs" do
    @io.readlines("").should == ["This is\n\n", "an example\n\n", "of paragraphs."]
  end
end

describe "IO#readlines" do
  before :each do
    @name = tmp("io_readlines")
  end

  after :each do
    rm_r @name
  end

  it "raises an IOError if the stream is opened for append only" do
    lambda do
      File.open(@name, fmode("a:utf-8")) { |f| f.readlines }
    end.should raise_error(IOError)
  end

  it "raises an IOError if the stream is opened for write only" do
    lambda do
      File.open(@name, fmode("w:utf-8")) { |f| f.readlines }
    end.should raise_error(IOError)
  end
end

describe "IO.readlines" do
  before(:each) do
    @name = fixture __FILE__, "readlines.txt"
  end

  describe "when passed [file_name]" do
    before :each do
      @sep, $/ = $/, " "
    end

    after :each do
      $/ = @sep
    end

    it "returns an Array containing lines of file_name based on $/" do
      IO.readlines(@name).should == ["Voici ", "la ", "ligne ", "une.\nQui ", "\303\250 ",
        "la ", "linea ", "due.\nAqu\303\255 ", "est\303\241 ", "la ", "l\303\255nea ",
        "tres.\nIst ", "hier ", "Linie ", "vier.\nEst\303\241 ", "aqui ", "a ",
        "linha ", "cinco.\nHere ", "is ", "line ", "six.\n"]
    end
  end

  describe "when passed [file_name]" do
    it "raises an Errno::ENOENT error when the passed file_name does not exist" do
      lambda { IO.readlines(tmp("nonexistent.txt")) }.should raise_error(Errno::ENOENT)
    end

    it "does not change $_" do
      $_ = "test"
      IO.readlines(@name)
      $_.should == "test"
    end

    it "tries to convert the passed file_name to a String using #to_str" do
      obj = mock('IO.readlines filename')
      obj.stub!(:to_str).and_return(@name)
      IO.readlines(obj).should == ["Voici la ligne une.\n",
        "Qui \303\250 la linea due.\n",
        "Aqu\303\255 est\303\241 la l\303\255nea tres.\n",
        "Ist hier Linie vier.\n", "Est\303\241 aqui a linha cinco.\n",
        "Here is line six.\n"]
    end
  end

  describe "when passed [file_name, separator]" do
    it "returns an Array containing lines of file_name based on the passed separator" do
      IO.readlines(@name, "r").should == [
        "Voici la ligne une.\nQui \303\250 la linea due.\nAqu\303\255 est\303\241 la l\303\255nea tr",
        "es.\nIst hier",
        " Linie vier",
        ".\nEst\303\241 aqui a linha cinco.\nHer",
        "e is line six.\n"]
    end

    it "does not change $_" do
      $_ = "test"
      IO.readlines(@name, "r")
      $_.should == "test"
    end

    it "tries to convert the passed separator to a String using #to_str" do
      obj = mock('IO.readlines filename')
      obj.stub!(:to_str).and_return("r")
      IO.readlines(@name, obj).should == [
        "Voici la ligne une.\nQui \303\250 la linea due.\nAqu\303\255 est\303\241 la l\303\255nea tr",
        "es.\nIst hier",
        " Linie vier",
        ".\nEst\303\241 aqui a linha cinco.\nHer",
        "e is line six.\n"]
    end
  end
end

describe "IO.readlines when passed an empty String as separator" do
  before :each do
    @name = fixture __FILE__, "paragraphs.txt"
  end

  it "returns an Array containing all paragraphs" do
    IO.readlines(@name, "").should == ["This is\n\n", "an example\n\n", "of paragraphs."]
  end
end
