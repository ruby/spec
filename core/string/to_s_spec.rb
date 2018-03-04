require_relative '../../spec_helper'
require_relative 'fixtures/classes.rb'
require_relative 'shared/to_s.rb'

describe "String#to_s" do
  it_behaves_like :string_to_s, :to_s
end
