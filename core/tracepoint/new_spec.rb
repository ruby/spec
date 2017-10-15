require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is '2.4' do
  describe 'TracePoint.new' do
    it 'returns a new TracePoint object, not enabled by default' do
      TracePoint.new(:call) {}.enabled?.should be_false
    end
  end
end
