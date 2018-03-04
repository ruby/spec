require_relative '../../spec_helper'
require_relative 'fixtures/classes.rb'
require_relative 'shared/succ.rb'

describe "String#succ" do
  it_behaves_like :string_succ, :succ
end

describe "String#succ!" do
  it_behaves_like :string_succ_bang, :"succ!"
end
