# -*- encoding: utf-8 -*-
require File.dirname(__FILE__) + '/../fixtures/classes'

describe :io_each, :shared => true do
  before :each do
    @io = IOSpecs.lines_fixture
    ScratchPad.record []
  end

  after :each do
    @io.close
  end

  it "yields each line to the passed block" do
    @io.send(@method) { |s| ScratchPad << s }
    ScratchPad.recorded.should == ["Voici la ligne une.\n",
      "Qui \303\250 la linea due.\n",
      "\n",
      "\n", "Aqu\303\255 est\303\241 la l\303\255nea tres.\n",
      "Ist hier Linie vier.\n",
      "\n",
      "Est\303\241 aqui a linha cinco.\n",
      "Here is line six.\n"]
  end

  it "yields each line starting from the current position" do
    @io.pos = 40
    @io.send(@method) { |s| ScratchPad << s }
    ScratchPad.recorded.should == ["\n", "\n", "\n", "Aqu\303\255 est\303\241 la l\303\255nea tres.\n", "Ist hier Linie vier.\n", "\n", "Est\303\241 aqui a linha cinco.\n", "Here is line six.\n"]
  end

  it "does not change $_" do
    $_ = "test"
    @io.send(@method) { |s| s }
    $_.should == "test"
  end

  it "returns self" do
    @io.send(@method) { |l| l }.should equal(@io)
  end

  it "raises an IOError when self is not readable" do
    # method must have a block in order to raise the IOError.
    # MRI 1.8.7 returns enumerator if block is not provided.
    # See [ruby-core:16557].
    lambda { IOSpecs.closed_file.send(@method){} }.should raise_error(IOError)
  end

  ruby_version_is "" ... "1.8.7" do
    it "raises a LocalJumpError when passed no block" do
      lambda { @io.send(@method) }.should raise_error(LocalJumpError)
    end
  end

  ruby_version_is "1.8.7" do
    it "returns an Enumerator when passed no block" do
      enum = @io.send(@method)
      enum.instance_of?(enumerator_class).should be_true

      seen = []
      enum.each { |b| seen << b }
      seen.should == ["Voici la ligne une.\n",
        "Qui \303\250 la linea due.\n",
        "\n",
        "\n", "Aqu\303\255 est\303\241 la l\303\255nea tres.\n",
        "Ist hier Linie vier.\n",
        "\n",
        "Est\303\241 aqui a linha cinco.\n",
        "Here is line six.\n"]
    end
  end
end

describe :io_each_default_separator, :shared => true do
  before :each do
    @io = File.open fixture(__FILE__, "paragraphs.txt"), fmode("r:utf-8")
    ScratchPad.record []
    @sep, $/ = $/, " "
  end

  after :each do
    @io.close
    $/ = @sep
  end

  it "uses $/ as the default line separator" do
    @io.send(@method) { |s| ScratchPad << s }
    ScratchPad.recorded.should == [
      "This ", "is\n\nan ", "example\n\n\n\nof ", "paragraphs."
    ]
  end
end

describe :io_each_separator, :shared => true do
  before :each do
    @io = IOSpecs.lines_fixture
    ScratchPad.record []
  end

  after :each do
    @io.close
  end

  it "uses the passed argument as the line separator" do
    @io.send(@method, " ") { |s| ScratchPad << s }
    ScratchPad.recorded.should == ["Voici ", "la ", "ligne ", "une.\nQui ", "\303\250 ", "la ",
      "linea ", "due.\n\n\nAqu\303\255 ", "est\303\241 ", "la ", "l\303\255nea ",
      "tres.\nIst ", "hier ", "Linie ", "vier.\n\nEst\303\241 ", "aqui ", "a ",
      "linha ", "cinco.\nHere ", "is ", "line ", "six.\n"]
  end

  it "does not change $_" do
    $_ = "test"
    @io.send(@method, " ") { |s| }
    $_.should == "test"
  end

  it "returns self" do
    @io.send(@method) { |l| l }.should equal(@io)
  end

  it "tries to convert the passed separator to a String using #to_str" do
    obj = mock("to_str")
    obj.stub!(:to_str).and_return(" ")

    @io.send(@method, obj) { |l| ScratchPad << l }
    ScratchPad.recorded.should == ["Voici ", "la ", "ligne ", "une.\nQui ", "\303\250 ", "la ",
      "linea ", "due.\n\n\nAqu\303\255 ", "est\303\241 ", "la ", "l\303\255nea ",
      "tres.\nIst ", "hier ", "Linie ", "vier.\n\nEst\303\241 ", "aqui ", "a ",
      "linha ", "cinco.\nHere ", "is ", "line ", "six.\n"]
  end

  it "yields self's content starting from the current position when the passed separator is nil" do
    @io.pos = 100
    @io.send(@method, nil) { |s| ScratchPad << s }
    ScratchPad.recorded.should == ["qui a linha cinco.\nHere is line six.\n"]
  end
end

describe :io_each_empty_separator, :shared => true do
  before :each do
    @io = File.open fixture(__FILE__, "paragraphs.txt"), fmode("r:utf-8")
    ScratchPad.record []
  end

  after :each do
    @io.close
  end

  it "yields each paragraph" do
    @io.send(@method, "") { |s| ScratchPad << s }
    ScratchPad.recorded.should == ["This is\n\n", "an example\n\n", "of paragraphs."]
  end
end
