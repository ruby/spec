require_relative '../../spec_helper'

describe "MatchData#==" do
  it "is an alias of MatchData#eql?" do
    MatchData.instance_method(:==).should == MatchData.instance_method(:eql?)
  end
end
