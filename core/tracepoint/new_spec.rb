require File.expand_path('../../../spec_helper', __FILE__)

module ClassSpecs
  class A
    def foo; end
  end
end

def test; 'test' end

ruby_version_is '2.0' do
  describe 'TracePoint.new' do
    it 'returns a new TracePoint object, not enabled by default' do
      TracePoint.new(:call) {}.enabled?.should be_false
    end

    it 'includes :line event when event is not specified' do
      event_name = nil
      TracePoint.new() { |tp| event_name = tp.event }.enable
      event_name.should equal(:line)

      event_name = nil
      test
      event_name.should equal(:line)

      event_name = nil
      ClassSpecs::A.new.foo
      event_name.should equal(:line)
    end

    it 'includes the matching event name if argument is string' do
      event_name = nil
      TracePoint.new('return') { |tp| event_name = tp.event}.enable
      event_name.should equal(nil)
      test
      event_name.should equal(:return)
    end

    it 'includes multiple events when multiple event names are passed as params' do
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
