require File.expand_path('../../../spec_helper', __FILE__)

describe "Resolv#getnames" do
  before :all do
    require 'resolv'
  end

  it "resolves 127.0.0.1" do
    res = Resolv.new([Resolv::Hosts.new])

    names = res.getnames("127.0.0.1")
    names.should_not == nil
    names.size.should > 0
  end
end
