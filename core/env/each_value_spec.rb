require_relative '../../spec_helper'
require_relative '../enumerable/shared/enumeratorized'

describe "ENV.each_value" do

  it "returns each value" do
    e = []
    orig = ENV.to_hash
    begin
      ENV.clear
      ENV["1"] = "3"
      ENV["2"] = "4"
      ENV.each_value { |v| e << v }
      e.should include("3")
      e.should include("4")
    ensure
      ENV.replace orig
    end
  end

  it "returns an Enumerator of the values if called without a block" do
    enum = ENV.each_value
    enum.should be_an_instance_of(Enumerator)
    env_values = ENV.values
    enum_values = []
    enum.each { |v| enum_values << v }
    enum_values.should == env_values
  end

  it "uses the locale encoding" do
    ENV.each_value do |value|
      value.encoding.should == Encoding.find('locale')
    end
  end

  it_behaves_like :enumeratorized_with_origin_size, :each_value, ENV
end
