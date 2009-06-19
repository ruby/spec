require File.dirname(__FILE__) + '/../../spec_helper'

ruby_version_is "1.9" do
  describe "Encoding#name" do
    it "returns a String" do
      Encoding.list.each do |e|
        e.name.should be_an_instance_of(String)
      end
    end

    it "uniquely identifies an encoding" do
      Encoding.list.each do |e|
        e.should == Encoding.find(e.name)
      end
    end
  end
end
