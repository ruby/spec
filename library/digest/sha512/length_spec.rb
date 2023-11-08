require_relative '../../../spec_helper'
require_relative 'shared/length'

describe "Digest::SHA512#length" do
  it_behaves_like :sha512_length, :length, Digest::SHA512.new
end
