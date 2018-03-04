require_relative '../../spec_helper'
require_relative 'shared/key.rb'

describe "ENV.index" do
  it_behaves_like :env_key, :index
end
