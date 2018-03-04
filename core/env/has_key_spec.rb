require_relative '../../spec_helper'
require_relative 'shared/include.rb'

describe "ENV.has_key?" do
  it_behaves_like :env_include, :has_key?
end
