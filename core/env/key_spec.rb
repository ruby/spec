require_relative '../../spec_helper'
require_relative 'shared/include.rb'
require_relative 'shared/key.rb'

describe "ENV.key?" do
  it_behaves_like :env_include, :key?
end

describe "ENV.key" do
  it_behaves_like :env_key, :key
end
