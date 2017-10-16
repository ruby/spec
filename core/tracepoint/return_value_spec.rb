require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is '2.0' do
  describe 'TracePoint#return_value' do
    def test; end

    it 'returns value from :return event' do
      trace_value = nil
      TracePoint.new(:return) { |tp| trace_value = tp.return_value}.enable
      test
      trace_value.should equal(nil)
    end
  end
end
