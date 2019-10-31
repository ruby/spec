require_relative '../../spec_helper'

ruby_version_is "2.7" do
  describe "ENV.methods" do
    it "includes new methods" do
      [:merge].each do |new_method|
        ENV.methods.should include(new_method)
      end
    end
  end
end

ruby_version_is "2.6" do
  describe "ENV.methods" do
    it "includes new methods" do
      [:filter, :filter!, :slice].each do |new_method|
       ENV.methods.should include(new_method)
      end
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
      expected_methods = [:[], :[]=, :assoc, :clear, :delete, :delete_if, :each, :each_key, :each_pair, :each_value, :empty?, :fetch, :has_key?, :has_value?, :include?, :index, :inspect, :invert, :keep_if, :key, :key?, :keys, :length, :member?, :rassoc, :rehash, :reject, :reject!, :replace, :select, :select!, :shift, :size, :store, :to_a, :to_h, :to_hash, :to_s, :update, :value?, :values, :values_at]
      expected_methods.each do |method|
        methods.should include(method)
      end
      # :pretty_print included by spec itself, apparently.
      (methods - expected_methods - [:filter, :filter!, :slice, :merge]).should == [:pretty_print]
    end
  end
end
