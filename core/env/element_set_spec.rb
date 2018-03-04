require_relative '../../spec_helper'
require_relative 'shared/store.rb'

describe "ENV.[]=" do
  it_behaves_like :env_store, :[]=
end
