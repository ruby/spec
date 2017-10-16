require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is '2.0' do
  describe 'TracePoint#defined_class' do
    module A; def bar; end; end

    class B
      include A
      def foo; end;
    end

    class C < B
      def initialize
        super
      end

      def foo
        super
      end

      def bar
        super
      end
    end

    it 'returns class or module of the method being called' do
      class_name = nil
      TracePoint.new(:call) do |tp|
        class_name = tp.defined_class
      end.enable

      B.new.foo
      class_name.should equal(B)

      B.new.bar
      class_name.should equal(A)

      c = C.new
      class_name.should equal(C)

      c.foo
      class_name.should equal(B)

      c.bar
      class_name.should equal(A)
    end
  end
end
