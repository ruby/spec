require_relative '../../spec_helper'
require_relative 'fixtures/classes.rb'
require_relative 'shared/to_sym.rb'

describe "String#intern" do
  it_behaves_like :string_to_sym, :intern
end
