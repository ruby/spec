module CoreClassSpecs
  class Record
    def self.called(sym)
      @called = sym
    end

    def self.called?
      @called
    end
  end

  module M
    def inherited(klass)
      ::CoreClassSpecs::Record.called(klass)
      super
    end
  end

  class F; end
  class << F
    include M
  end

  class A
    def self.inherited(klass)
      ::CoreClassSpecs::Record.called(klass)
    end
  end

  class H < A
    def self.inherited(klass)
      super
    end
  end

  module Inherited
    class A
      SUBCLASSES = []
      def self.inherited(subclass)
        SUBCLASSES << [self, subclass]
      end
    end

    class B < A; end
    class B < A; end # reopen
    class C < B; end

    class D
      def self.inherited(subclass)
        ScratchPad << self
      end
    end
  end
  
  # Can't use a method here because of class definition in method body error
  ANON_CLASS_FOR_NEW = lambda do
    Class.new do
      class NamedInModule
      end

      def self.get_class_name
        NamedInModule.name
      end  
    end
  end
end
