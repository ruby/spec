require_relative '../../spec_helper'

ruby_version_is "3.0" do
  describe "Symbol#name" do
    it "returns a string" do
      :ruby.name.should == "ruby"
      :ルビー.name.should == "ルビー"
      :"ruby_#{1+2}".name.should == "ruby_3"
    end

    it "returns a frozen string" do
      :symbol.name.should.frozen?
    end
  end
end
