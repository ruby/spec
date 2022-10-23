require_relative '../../spec_helper'

describe "Process._fork" do
  ruby_version_is ""..."3.1" do
    it "raises NoMethodError" do
      -> { Process._fork }.should raise_error(NoMethodError)
    end
  end

  ruby_version_is "3.1" do
    platform_is :windows do
      it "returns false from #respond_to?" do
        Process.respond_to?(:_fork).should be_false
      end

      it "raises a NotImplementedError when called" do
        -> { Process._fork }.should raise_error(NotImplementedError)
      end
    end

    platform_is_not :windows do
      it "returns true from #respond_to?" do
        Process.respond_to?(:_fork).should be_true
      end

      it "is called by Process#fork" do
        Process.should_receive(:_fork).once.and_return(42)

        pid = Process.fork {}
        pid.should equal(42)
      end
    end
  end
end
