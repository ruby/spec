require_relative '../../spec_helper'

ruby_version_is "3.0" do
  describe "Symbol#name" do
    it "returns a frozen string" do
      :symbol.name.should.frozen?
    end
  end
end
