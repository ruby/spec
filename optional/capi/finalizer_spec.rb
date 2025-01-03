require_relative "spec_helper"

extension_path = load_extension("finalizer")

describe "CApiFinalizerSpecs" do
  before :each do
    @s = CApiFinalizerSpecs.new
  end

  describe "rb_define_finalizer" do
    it "defines a finalizer on the object" do
      code = <<~RUBY
        require #{extension_path.dump}

        obj = Object.new
        finalizer = Proc.new { puts "finalizer run" }
        CApiFinalizerSpecs.new.rb_define_finalizer(obj, finalizer)
      RUBY

      ruby_exe(code).should == "finalizer run\n"
    end
  end
end
