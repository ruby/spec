require_relative '../../spec_helper'
require_relative 'fixtures/common'
require_relative 'fixtures/strings'
require_relative 'shared/unsafe_load'

describe "YAML.load" do
  after :each do
    rm_r $test_file
  end

  it "returns a document from current io stream when io provided" do
    File.open($test_file, 'w') do |io|
      YAML.dump( ['badger', 'elephant', 'tiger'], io )
    end
    File.open($test_file) { |yf| YAML.load( yf ) }.should == ['badger', 'elephant', 'tiger']
  end

  it "loads strings" do
    strings = ["str",
               " str",
               "'str'",
               "str",
               " str",
               "'str'",
               "\"str\"",
                "\n str",
                "---  str",
                "---\nstr",
                "--- \nstr",
                "--- \n str",
                "--- 'str'"
              ]
    strings.each do |str|
      YAML.load(str).should == "str"
    end
  end

  it "loads strings with chars from non-base Unicode plane" do
    # We add these strings as bytes and force the encoding for safety
    # as bugs in parsing unicode characters can obscure bugs in this
    # area.

    yaml_and_strings = {
      # "--- 🌵" => "🌵"
      [45, 45, 45, 32, 240, 159, 140, 181] =>
      [240, 159, 140, 181],
      # "--- 🌵 and some text" => "🌵 and some text"
      [45, 45, 45, 32, 240, 159, 140, 181, 32, 97, 110, 100, 32, 115, 111, 109, 101, 32, 116, 101, 120, 116] =>
      [240, 159, 140, 181, 32, 97, 110, 100, 32, 115, 111, 109, 101, 32, 116, 101, 120, 116],
      # "--- Some text 🌵 and some text" => "Some text 🌵 and some text"
      [45, 45, 45, 32, 83, 111, 109, 101, 32, 116, 101, 120, 116, 32, 240, 159, 140, 181, 32, 97, 110, 100, 32, 115, 111, 109, 101, 32, 116, 101, 120, 116] =>
      [83, 111, 109, 101, 32, 116, 101, 120, 116, 32, 240, 159, 140, 181, 32, 97, 110, 100, 32, 115, 111, 109, 101, 32, 116, 101, 120, 116]
    }
    yaml_and_strings.each do |yaml, str|
      YAML.load(yaml.pack("C*").force_encoding("UTF-8")).should == str.pack("C*").force_encoding("UTF-8")
    end
  end

  it "fails on invalid keys" do
    if YAML.to_s == "Psych"
      error = Psych::SyntaxError
    else
      error = ArgumentError
    end
    -> { YAML.load("key1: value\ninvalid_key") }.should raise_error(error)
  end

  it "accepts symbols" do
    YAML.load( "--- :locked" ).should == :locked
  end

  it "accepts numbers" do
    YAML.load("47").should == 47
    YAML.load("-1").should == -1
  end

  it "accepts collections" do
    expected = ["a", "b", "c"]
    YAML.load("--- \n- a\n- b\n- c\n").should == expected
    YAML.load("--- [a, b, c]").should == expected
    YAML.load("[a, b, c]").should == expected
  end

  it "parses start markers" do
    YAML.load("---\n").should == nil
    YAML.load("--- ---\n").should == "---"
    YAML.load("--- abc").should == "abc"
  end

  it "works with block sequence shortcuts" do
    block_seq = "- - - one\n    - two\n    - three"
    YAML.load(block_seq).should == [[["one", "two", "three"]]]
  end

  it "loads a symbol key that contains spaces" do
    string = ":user name: This is the user name."
    expected = { :"user name" => "This is the user name."}
    YAML.load(string).should == expected
  end

  guard -> { Psych::VERSION < '4.0.0' } do
    it_behaves_like :yaml_unsafe_load, :load
  end
end
