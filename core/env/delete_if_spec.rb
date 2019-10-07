require_relative '../../spec_helper'
require_relative '../enumerable/shared/enumeratorized'

describe "ENV.delete_if" do
  before :each do
    @saved_envvars = ENV.slice("foo", "bar")
  end

  after :each do
    ENV.update(@saved_envvars)
  end

  it "deletes pairs if the block returns true" do
    ENV.update("foo" => "0", "bar" => "1")
    ENV.delete_if { |k, v| ["foo", "bar"].include?(k) }
    ENV.slice("foo", "bar").should be_empty
  end

  it "returns ENV when block given" do
    ENV.update("foo" => "0", "bar" => "1")
    ENV.delete_if { |k, v| ["foo", "bar"].include?(k) }.should equal(ENV)

  end

  it "returns ENV even if nothing deleted" do
    ENV.delete_if { false }.should equal(ENV)
  end

  it "returns an Enumerator if no block given" do
    ENV.delete_if.should be_an_instance_of(Enumerator)
  end

  it "deletes pairs through enumerator" do
    ENV.update("foo" => "0", "bar" => "1")
    enum = ENV.delete_if
    enum.each { |k, v| ["foo", "bar"].include?(k) }
    ENV.slice("foo", "bar").should be_empty
  end

  it "returns ENV from enumerator" do
    ENV.update("foo" => "0", "bar" => "1")
    enum = ENV.delete_if
    enum.each { |k, v| ["foo", "bar"].include?(k) }.should equal(ENV)
  end

  it "returns ENV from enumerator even if nothing deleted" do
    enum = ENV.delete_if
    enum.each { false }.should equal(ENV)
  end

  it_behaves_like :enumeratorized_with_origin_size, :delete_if, ENV
end
