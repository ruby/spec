require File.expand_path('../../../fixtures/rational', __FILE__)

describe :rational_arithmetic_exception_in_coerce, shared: true do
  ruby_version_is "" ... "2.5" do
    it "rescues exception raised in other#coerce and raises TypeError" do
      b = mock("numeric with failed #coerce")
      b.should_receive(:coerce).and_raise(RuntimeError)

      # e.g. Rational(3, 4) + b
      -> { Rational(3, 4).send(@method, b) }.should raise_error(TypeError, /MockObject can't be coerced into Rational/)
    end
  end

  ruby_version_is "2.5" do
    it "does not rescue exception raised in other#coerce" do
      b = mock("numeric with failed #coerce")
      b.should_receive(:coerce).and_raise(RationalSpecs::CoerceError)

      # e.g. Rational(3, 4) + b
      -> { Rational(3, 4).send(@method, b) }.should raise_error(RationalSpecs::CoerceError)
    end
  end
end
