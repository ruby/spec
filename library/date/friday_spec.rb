require File.expand_path('../../../spec_helper', __FILE__)
require 'date'

describe "Date#friday?" do
  it "should be friday" do
    Date.new(2000, 1, 7).friday?.should be_true
  end
end
