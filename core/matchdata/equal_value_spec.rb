require File.dirname(__FILE__) + '/../../spec_helper'

ruby_version_is "1.9" do
  describe "MatchData#==" do
    it "returns true if both operands have equal target strings, patterns, and match positions" do
      a = 'haystack'.match(/hay/)
      b = 'haystack'.match(/hay/)
      a.should == b
    end

    it "returns false if the operands have different target strings" do
      a = 'hay'.match(/hay/)
      b = 'haystack'.match(/hay/)
      a.should_not == b
    end

    it "returns false if the operands have different patterns" do
      a = 'haystack'.match(/h.y/)
      b = 'haystack'.match(/hay/)
      a.should_not == b
    end

    it "returns false if the argument is not a MatchData object" do
      a = 'haystack'.match(/hay/)
      a.should_not == Object.new
    end
  end
end
