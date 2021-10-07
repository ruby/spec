require_relative '../../spec_helper'
require_relative 'shared/join'
require 'set'

ruby_version_is "3.0" do
  describe "Set#join" do
    it "returns an empty string if the Set is empty" do
      Set[].join.should == ''
    end

    it_behaves_like :set_join, :join
  end
end
