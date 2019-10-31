require_relative '../../spec_helper'

ruby_version_is "2.7" do
  describe "ENV.methods" do
    it "includes method :merge"
    ENV.methods.should include(:merge)
  end
end

ruby_version_is "2.6" do
  describe "ENV.methods" do
    it "includes method :slice" do
      ENV.methods.should include(:slice)
    end
  end
end

ruby_version_is "2.5" do
  describe "ENV.class" do
    ENV.should be_an_instance_of(Object)
  end

  describe "ENV.methods" do
    it "returns an array of methods" do
      methods = ENV.methods false
      expected_methods = [:[], :[]=, :assoc, :clear, :delete, :delete_if, :each, :each_key, :each_pair, :each_value, :empty?, :fetch, :filter, :filter!, :has_key?, :has_value?, :include?, :index, :inspect, :invert, :keep_if, :key, :key?, :keys, :length, :member?, :rassoc, :rehash, :reject, :reject!, :replace, :select, :select!, :shift, :size, :store, :to_a, :to_h, :to_hash, :to_s, :update, :value?, :values, :values_at]
      expected_methods.each do |method|
        methods.should include(method)
      end
      # :pretty_print included by spec itself, apparently.
      (methods - expected_methods - [:slice, :merge]).should == [:pretty_print]
    end
  end
end
