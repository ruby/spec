require File.dirname(__FILE__) + '/../../spec_helper'
require 'iconv'

describe "Iconv#close" do
  it "fails silently if called more than once" do
    conv1 = Iconv.new("us-ascii", "us-ascii")
    lambda {
      conv1.close
      conv1.close
    }.should_not raise_error

    lambda {
      Iconv.open "us-ascii", "us-ascii" do |conv2|
        conv2.close
      end
    }.should_not raise_error
  end

  # return values of #close not tested yet
end
