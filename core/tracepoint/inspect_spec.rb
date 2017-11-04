require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is '2.0' do
  describe 'TracePoint#inspect' do
    it 'returns a string containing a human-readable TracePoint status' do
      TracePoint.new(:call) {}.inspect.should ==
        '#<TracePoint:disabled>'
    end
  end
end
