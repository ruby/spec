require_relative "../spec_helper"

describe "magic comments in ractors" do
  ruby_version_is "3.0" do
    it "makes constants shareable between ractors" do
      out = ruby_exe(fixture(__FILE__, "shareable_constant_value_magic_comment.rb"), options: "-W0")
      out.should == "ractor"
    end

    it "makes constants shareable between ractors" do
      a, b, c = Class.new.class_eval(<<~RUBY, __FILE__, __LINE__ + 1)
        # shareable_constant_value: experimental_everything
        A = [[1]]
        # shareable_constant_value: none
        B = [[2]]
        # shareable_constant_value: literal
        C = [["shareable", "constant#{self.class.name}"]]
        [A, B, C]
      RUBY
      Ractor.shareable?(a).should == true
      Ractor.shareable?(b).should == false
      Ractor.shareable?(c).should == true
    end

    context "when a shared constant is not a literal" do
      it "raises an error when is computed" do
        -> { Class.new.class_eval(<<~RUBY, __FILE__, __LINE__ + 1) }.should raise_error(Ractor::IsolationError, "cannot assign unshareable object to C")
          # shareable_constant_value: literal
          C = ["Not " + "shareable"]
        RUBY
      end

      it "raises an error when referencing a non-frozen variable" do
        -> { Class.new.class_eval(<<~RUBY, __FILE__, __LINE__ + 1) }.should raise_error(Ractor::IsolationError, "cannot assign unshareable object to C")
          # shareable_constant_value: literal
          value = "value"
          C = value
        RUBY
      end
    end
  end
end
