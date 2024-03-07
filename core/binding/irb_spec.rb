require_relative '../../spec_helper'

describe "Binding#irb" do
  before :each do
    @env_home = ENV["HOME"]
    ENV["HOME"] = CODE_LOADING_DIR
  end

  after :each do
    ENV["HOME"] = @env_home
  end

  it "creates an IRB session with the binding in scope" do
    irb_fixture = fixture __FILE__, "irb.rb"

    out = IO.popen([*ruby_exe, irb_fixture], "r+") do |pipe|
      pipe.puts "a ** 2"
      pipe.puts "exit"
      pipe.readlines.map(&:chomp)
    end

    out[-3..-1].should == ["a ** 2", "100", "exit"]
  end
end
