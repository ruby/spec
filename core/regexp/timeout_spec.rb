require_relative '../../spec_helper'

ruby_version_is "3.2" do
  describe "Regexp.timeout" do
    it "returns global timeout" do
      Regexp.timeout = 3
      Regexp.timeout.should == 3
    end

    it "raises Regexp::TimeoutError after global timeout elapsed" do
      Regexp.timeout = 0.2
      Regexp.timeout.should == 0.2

      t = Time.now
      -> {
        # A typical ReDoS case
        /^(a*)*$/ =~ "a" * 1000000 + "x"
      }.should raise_error(Regexp::TimeoutError, "regexp match timeout")
      t = Time.now - t
      t.should be_close(0.2, 0.1)
    end

    it "raises Regexp::TimeoutError after timeout keyword value elapsed" do
      Regexp.timeout = 3 # This should be ignored
      Regexp.timeout.should == 3

      re = Regexp.new("^a*b?a*$", timeout: 0.2)

      t = Time.now
      -> {
        re =~ "a" * 1000000 + "x"
      }.should raise_error(Regexp::TimeoutError, "regexp match timeout")
      t = Time.now - t

      t.should be_close(0.2, 0.1)
    end
  end
end
