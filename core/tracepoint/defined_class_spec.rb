require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is '2.0' do
  describe 'TracePoint#defined_class' do
    class A; def foo; end; end

    it 'returns class or module of the method being called' do
      class_name = nil
      TracePoint.new(:call) do |tp|
        class_name = tp.defined_class
      end.enable do
        A.new.foo
        class_name.should equal(A)
      end
    end
  end
end
