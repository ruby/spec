require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/shared/add'
require 'set'

describe "Set#add" do
  it_behaves_like :set_add, Set, :add
end

describe "Set#add?" do
  it_behaves_like :set_add_p, Set
end
