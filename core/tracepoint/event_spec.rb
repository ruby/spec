require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is '2.0' do
  describe 'TracePoint#event' do
    def test; 'test' end
    class A; def foo; end end

    it 'returns the type of event' do
      event_name = nil
      TracePoint.new(:end, :call) do |tp|
        event_name = tp.event
      end.enable

      test
      event_name.should equal(:call)

      A.new.foo
      event_name.should equal(:call)

      class B; end
      event_name.should equal(:end)
    end
  end
end
