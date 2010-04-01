require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is "1.9" do
  describe "Random#marshall_{load,save}" do
    before :each do
      @rnd = Random.new(42)
      1000.times{ @rnd.rand }  # exhaust the first batch of numbers
      @rnd2 = Marshall.load(Marshall.dump(@rnd))
    end

    it "produces objects that are ==" do
      @rnd2.should == @rnd
    end

    it "produces objects giving the same random numbers" do
      @rnd2.rand.should == @rnd.rand
    end

    it "restores the seed" do
      @rnd2.seed.should == 42
    end
  end
end
