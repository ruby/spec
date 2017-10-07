require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is '2.4' do
  describe "Integer#dup" do
    it "returns self" do
      2.dup.should equal(2)
    end
  end
end
