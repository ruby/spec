require_relative '../../spec_helper'
require_relative 'shared/slice.rb'

describe "Symbol#[]" do
  it_behaves_like :symbol_slice, :[]
end
