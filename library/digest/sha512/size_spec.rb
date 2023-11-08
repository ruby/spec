require_relative '../../../spec_helper'
require_relative 'shared/length'

describe "Digest::SHA512#size" do
  it_behaves_like :sha512_length, :size, Digest::SHA512.new
end
