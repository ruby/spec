require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

ruby_version_is '2.3' do
  describe "Thread#name" do
    before do
      @thread = Thread.new { 3 }
      @thread.name = :thread_name
    end

    it "returns the thread name" do
      @thread.name.should == :thread_name
    end
  end

  describe "Thread#name=" do
    it "sets a different thread name" do
      @thread.name = :new_thread_name
      @thread.name.should == :new_thread_name
    end
  end
end
