require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is '2.4' do
  describe 'TracePoint#disable' do
    context 'deactivates the trace' do
      it 'returns true if trace was enabled' do
        trace = TracePoint.new(:call) {}
        trace.enable
        trace.disable.should be_true
      end

      it 'returns false if trace was disabled' do
        trace = TracePoint.new(:call) {}
        trace.enable
        trace.disable
        trace.disable.should be_false
      end
    end
  end
end
