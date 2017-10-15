require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is '2.4' do
  describe 'TracePoint#raised_exception' do
    it 'returns value from exception raised on the :raise event' do
      value = nil
      trace = TracePoint.new(:raise) { |tp| value = tp.raised_exception }
      trace.enable
      begin
        raise StandardError
      rescue => _ ; end
      value.should be_kind_of(StandardError)
    end
  end
end
