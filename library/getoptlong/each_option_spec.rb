require_relative '../../spec_helper'
require 'getoptlong'

describe "GetoptLong#each_option" do
  it "is an alias of GetoptLong#each" do
    GetoptLong.instance_method(:each_option).should == GetoptLong.instance_method(:each)
  end
end
