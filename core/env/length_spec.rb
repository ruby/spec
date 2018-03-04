require_relative '../../spec_helper'
require_relative 'shared/length.rb'

describe "ENV.length" do
 it_behaves_like :env_length, :length
end
