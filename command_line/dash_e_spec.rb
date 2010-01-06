require File.dirname(__FILE__) + '/../spec_helper'

describe "The -e command line option" do
  it "evaluates the given string" do
    ruby_exe("puts 'foo'").chomp.should == "foo"
  end

  it "joins multiple strings with newlines" do
    ruby_exe(nil, :args => %Q{-e "puts 'hello" -e "world'"}).chomp.should == "hello\nworld"
  end

  it "uses 'main' as self" do
    ruby_exe("puts self").chomp.should == "main"
  end

  it "uses '-e' as file" do
    ruby_exe("puts __FILE__").chomp.should == "-e"
  end

  #needs to test return => LocalJumpError
end

describe "The if expression with a range with two Fixnums under the -e command line option" do
  it "considers the range as an awk-like conditional operator that the two values are compared with $. if the end value is not excluded" do
    ruby_exe(nil, :args => %Q{-ne "print if 2..3" fixtures/conditional_range.txt}, :dir => File.dirname(__FILE__)).chomp.should == "2\n3"
    ruby_exe(nil, :args => %Q{-ne "print if 2..2" fixtures/conditional_range.txt}, :dir => File.dirname(__FILE__)).chomp.should == "2"
  end

  it "considers the range as a sed-like conditional operator that the two values are compared with $. if the end value is excluded" do
    ruby_exe(nil, :args => %Q{-ne "print if 2...3" fixtures/conditional_range.txt}, :dir => File.dirname(__FILE__)).chomp.should == "2\n3"
    ruby_exe(nil, :args => %Q{-ne "print if 2...2" fixtures/conditional_range.txt}, :dir => File.dirname(__FILE__)).chomp.should == "2\n3\n4\n5"
  end
end

