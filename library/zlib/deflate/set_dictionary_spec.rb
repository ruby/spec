require_relative '../../../spec_helper'
require_relative '../spec_helper'
require 'zlib'

describe "Zlib::Deflate#set_dictionary" do
  it "sets the dictionary" do
    stdout = ruby_exe(<<~'RUBY', options: '-rzlib', env: Zlib::CHILD_ENV)
      d = Zlib::Deflate.new
      d.set_dictionary 'aaaaaaaaaa'
      d << 'abcdefghij'

      puts d.finish == [120, 187, 20, 225, 3, 203, 75, 76,
                        74, 78, 73, 77, 75, 207, 200, 204,
                        2, 0, 21, 134, 3, 248].pack('C*')

    RUBY

    stdout.should == "true\n"
  end
end
