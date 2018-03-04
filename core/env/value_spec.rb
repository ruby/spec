require_relative '../../spec_helper'
require_relative 'shared/value.rb'

describe "ENV.value?" do
  it_behaves_like :env_value, :value?
end
