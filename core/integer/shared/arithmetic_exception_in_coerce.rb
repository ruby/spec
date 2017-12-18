require File.expand_path('../../fixtures/classes', __FILE__)

describe :integer_arithmetic_exception_in_coerce, shared: true do
  ruby_version_is "" ... "2.5" do
    it "rescues exception raised in other#coerce and raises TypeError" do
      b = mock("numeric with failed #coerce")
      b.should_receive(:coerce).and_raise(RuntimeError)

      # e.g. 1 + b
      -> { 1.send(@method, b) }.should raise_error(TypeError, /MockObject can't be coerced into #{1.class}/)
    end
  end

  ruby_version_is "2.5" do
    it "does not rescue exception raised in other#coerce" do
      b = mock("numeric with failed #coerce")
      b.should_receive(:coerce).and_raise(IntegerSpecs::CoerceError)

      # e.g. 1 + b
      -> { 1.send(@method, b) }.should raise_error(IntegerSpecs::CoerceError)
    end
  end
end
