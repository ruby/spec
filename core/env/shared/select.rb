describe :env_select, shared: true do
  it "returns a Hash of names and values for which block return true" do
    @saved_foo = ENV["foo"]
    ENV["foo"] = "bar"
    (ENV.send(@method) { |k, v| k == "foo" }).should == { "foo" => "bar" }
    ENV["foo"] = @saved_foo
  end

  it "returns an Enumerator when no block is given" do
    enum = ENV.send(@method)
    enum.should be_an_instance_of(Enumerator)
    enum.to_h.should == ENV.to_h
  end
end

describe :env_select!, shared: true do
  before :each do
    @saved_foo = ENV["foo"]
  end

  after :each do
    ENV["foo"] = @saved_foo
  end

  it "removes environment variables for which the block returns true" do
    ENV["foo"] = "bar"
    ENV.send(@method) { |k, v| k != "foo" }
    ENV["foo"].should == nil
  end

  it "returns self if any changes were made" do
    ENV["foo"] = "bar"
    (ENV.send(@method) { |k, v| k != "foo" }).should equal(ENV)
  end

  it "returns nil if no changes were made" do
    (ENV.send(@method) { true }).should == nil
  end

  it "returns an Enumerator if called without a block" do
    enum = ENV.send(@method)
    enum.should be_an_instance_of(Enumerator)
    enum.to_h.should == ENV.to_h
  end
end
