require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/shared/get_byte'
require 'strscan'

describe "StringScanner#getbyte" do
    it_behaves_like :strscan_get_byte, :getbyte
end
