require_relative '../../spec_helper'

require 'yaml'

describe "YAML.dump" do
  before :each do
    @test_file = tmp("yaml_test_file")
  end

  after :each do
    rm_r @test_file
  end

  it "converts an object to YAML and write result to io when io provided" do
    File.open(@test_file, 'w' ) do |io|
      YAML.dump( ['badger', 'elephant', 'tiger'], io )
    end
    YAML.load_file(@test_file).should == ['badger', 'elephant', 'tiger']
  end

  it "returns a string containing dumped YAML when no io provided" do
    YAML.dump( :locked ).should match_yaml("--- :locked\n")
  end

  it "returns the same string that #to_yaml on objects" do
    ["a", "b", "c"].to_yaml.should == YAML.dump(["a", "b", "c"])
  end

  it "dumps strings into YAML strings" do
    YAML.dump("str").should match_yaml("--- str\n")
  end

  it "dumps hashes into YAML key-values" do
    YAML.dump({ "a" => "b" }).should match_yaml("--- \na: b\n")
  end

  it "dumps Arrays into YAML collection" do
    YAML.dump(["a", "b", "c"]).should match_yaml("--- \n- a\n- b\n- c\n")
  end

  it "dumps an OpenStruct" do
    begin
      require "ostruct"
    rescue LoadError
      skip "OpenStruct is not available"
    end
    os = OpenStruct.new("age" => 20, "name" => "John")
    yaml_dump = YAML.dump(os)

    [
      "--- !ruby/object:OpenStruct\nage: 20\nname: John\n",
      "--- !ruby/object:OpenStruct\ntable:\n  :age: 20\n  :name: John\n",
    ].should.include?(yaml_dump)
  end

  it "dumps a File without any state" do
    file = File.new(__FILE__)
    begin
      YAML.dump(file).should match_yaml("--- !ruby/object:File {}\n")
    ensure
      file.close
    end
  end
end
