require_relative '../../spec_helper'
require_relative 'spec_helper'
require "zlib"

describe "Zlib.deflate" do
  it "deflates some data" do
    stdout = ruby_exe(<<~'RUBY', options: '-rzlib', env: Zlib::CHILD_ENV)
      puts Zlib.deflate("1" * 10) == [120, 156, 51, 52, 132, 1, 0, 10, 145, 1, 235].pack('C*')
    RUBY

    stdout.should == "true\n"
  end
end
