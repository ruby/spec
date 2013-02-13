require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is "1.8.7" do
  describe "Symbol#to_proc" do
    it "returns a new Proc" do
      proc = :to_s.to_proc
      proc.should be_kind_of(Proc)
    end

    it "sends self to arguments passed when calling #call on the proc" do
      obj = mock("Receiving #to_s")
      obj.should_receive(:to_s).and_return("Received #to_s")
      :to_s.to_proc.call(obj).should == "Received #to_s"
    end

    ruby_version_is "1.9" do
      it "accepts a block and can yield to it when calling #call on the proc" do
        yielded = Object.new
        def f; yield; end
        :f.to_proc.call(self) { yielded }.should == yielded
      end
    end
  end
end
