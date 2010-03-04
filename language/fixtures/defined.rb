module DefinedSpecs
  class ClassWithMethod
    def test
    end
  end

  class ClassUndefiningMethod < ClassWithMethod
    undef :test
  end

  class ClassWithoutMethod < ClassUndefiningMethod
    # If an undefined method overridden in descendants
    # define?(super) should return nil
    def test
      defined?(super)
    end
  end

  class ClassWithMissingMethod
    def respond_to_missing?(*)
      true
    end
  end
end
