require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is '2.4' do
  describe 'TracePoint#lineno' do
    it 'returns the line number of the event' do
      lineno = nil
      TracePoint.new(:line) { |tp| lineno = tp.lineno }.enable
      lineno.should equal(8)
    end
  end
end
