require File.dirname(__FILE__) + '/../../spec_helper'

describe "ARGF" do
  it "is Enumerable" do
    ARGF.should be_kind_of(Enumerable)
  end
end
