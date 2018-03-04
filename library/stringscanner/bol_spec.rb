require_relative '../../spec_helper'
require_relative 'shared/bol.rb'
require 'strscan'

describe "StringScanner#bol?" do
  it_behaves_like :strscan_bol, :bol?
end
