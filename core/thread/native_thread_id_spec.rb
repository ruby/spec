require_relative '../../spec_helper'

ruby_version_is ''...'3.1' do
  describe "Thread#native_thread_id" do
    it "raises NoMethodError" do
      -> {
        th = Thread.new {}
        th.native_thread_id
      }.should raise_error(NoMethodError)
    end
  end
end

ruby_version_is "3.1" do
  describe "Thread#native_thread_id" do
    it "returns an integer" do
      th = Thread.new {}
      th.native_thread_id.should be_kind_of(Integer)
    end
  end
end
