require_relative '../../spec_helper'

ruby_version_is "2.6" do
  describe "ENV.slice" do
    before :each do
      @saved = {
          "foo" => ENV["foo"],
          "bar" => ENV["bar"],
          "bat" => ENV["bat"],
      }
      @pairs = {
          "foo" => "0",
          "bar" => "1",
          "bat" => "2",
      }
      ENV.update(@pairs)
    end

    after :each do
      ENV.update(@saved)
    end

    it "returns a hash of the given environment variable names and their values" do
      ENV.slice(*@pairs.keys).should == @pairs
    end

    it "ignores each String that is not an environment variable name" do
      pairs = @pairs.clone
      pairs.delete("bar")
      ENV.delete("bar")
      ENV.slice(*@pairs.keys).should == pairs
    end

    it "raises TypeError if any argument is not a String and does not respond to #to_str" do
      pairs = @pairs.clone
      pairs[Object.new] = "3"
      -> { ENV.slice(*pairs.keys) }.should raise_error(TypeError)
    end
  end
end
