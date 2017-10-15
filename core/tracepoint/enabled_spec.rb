require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is '2.4' do
  describe 'TracePoint#enabled?' do
    it 'returns the current status of the trace' do
      TracePoint.new(:call) {}.enabled?.should be_false
    end
  end
end
