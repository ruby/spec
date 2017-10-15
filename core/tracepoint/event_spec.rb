require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is '2.4' do
  describe 'TracePoint#event' do
    it 'returns the type of event' do
      event_name = nil
      TracePoint.new(:line) { |tp| event_name = tp.event }.enable
      event_name.should equal(:line)
    end
  end
end
