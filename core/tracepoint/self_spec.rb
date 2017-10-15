require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is '2.4' do
  describe 'TracePoint#self' do
    it 'return the trace object from event' do
      trace = nil
      TracePoint.new(:line) { |tp| trace = tp.self }.enable
      trace.should be_kind_of(MSpecEnv)
    end
  end
end
