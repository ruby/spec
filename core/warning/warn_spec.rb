require File.expand_path("../../../spec_helper", __FILE__)

describe "Warning.warn" do
  ruby_version_is "2.4" do
    it "complains" do
      -> {
        Warning.warn("Chunky bacon!")
      }.should complain("Chunky bacon!")
    end
  end
end
