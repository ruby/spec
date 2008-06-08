require File.dirname(__FILE__) + '/../../spec_helper'
require 'stringio'
require File.dirname(__FILE__) + "/shared/each_byte"

describe "StringIO#bytes" do
  it_behaves_like :stringio_each_byte, :bytes
end
