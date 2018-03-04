require_relative '../../spec_helper'
require_relative 'fixtures/classes.rb'
require_relative 'shared/succ.rb'

describe "String#next" do
  it_behaves_like :string_succ, :next
end

describe "String#next!" do
  it_behaves_like :string_succ_bang, :"next!"
end
