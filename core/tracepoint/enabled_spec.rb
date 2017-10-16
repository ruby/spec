require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is '2.0' do
  describe 'TracePoint#enabled?' do
    it 'returns true when current status of the trace is enable' do
      trace = TracePoint.new(:call) {}
      trace.enable
      trace.enabled?.should be_true
    end

    it 'returns false when current status of the trace is disabled' do
      TracePoint.new(:call) {}.enabled?.should be_false
    end
  end
end
