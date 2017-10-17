require File.expand_path('../../../spec_helper', __FILE__)

module ClassSpecs
  class A
    def foo; end
  end
end

def test; 'test' end

ruby_version_is '2.0' do
  describe 'TracePoint#event' do
    it 'returns the type of event' do
      event_name = nil
      TracePoint.new(:end, :call) do |tp|
        event_name = tp.event
      end.enable

      test
      event_name.should equal(:call)

      ClassSpecs::A.new.foo
      event_name.should equal(:call)

      class B; end
      event_name.should equal(:end)
    end
  end
end
