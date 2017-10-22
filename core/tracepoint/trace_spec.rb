require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is '2.0' do
  describe 'TracePoint.trace' do
    it 'activates the trace automatically' do
      trace = TracePoint.trace(:call) {}
      trace.enabled?.should be_true
      trace.disable
    end
  end
end
