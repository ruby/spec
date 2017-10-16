require File.expand_path("../../../spec_helper", __FILE__)

describe "Warning.warn" do
  ruby_version_is "2.4" do
    it "complains" do
      -> {
        Warning.warn("Chunky bacon!")
      }.should complain("Chunky bacon!")
    end

    it "extends itself" do
      Warning.ancestors.should include(Warning)
    end

    ruby_version_is "2.5" do
      it "is called by Kernel.warn" do
        Warning.should_receive(:warn)
        Kernel.warn("Chunky bacon!")
      end

      it "is also called by parser warnings" do
        Warning.should_receive(:warn)
        eval "{ key: :value, key: :value2 }"
      end
    end
  end
end
