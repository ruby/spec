require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is "2.5" do
  describe "Hash#slice" do
    before :each do
      @hsh = { a: 1, b: 2, c: 3 }
    end

    it "returns a Hash of the sliced keys" do
      @hsh.slice(:a, :c).should == { a: 1, c: 3 }
    end

    it "returns only the keys of the original hash" do
      @hsh.slice(:a, :chunky_bacon).should == { a: 1 }
    end
  end
end
