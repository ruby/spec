require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'
require File.dirname(__FILE__) + '/shared/equal'
require File.dirname(__FILE__) + '/shared/equal_more'

describe "Hash#==" do
  it_behaves_like :hash_equal, :==
  it_behaves_like :hash_equal_more, :==
  
  it "compares values with == semantics" do
    new_hash("x" => 1.0).should == new_hash("x" => 1)
  end
end