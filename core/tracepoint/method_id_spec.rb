require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is '2.4' do
  describe 'TracePoint#method_id' do
    def test; end

    it 'returns the name at the definition of the method being called' do
      method_name = nil
      TracePoint.new(:call) { |tp| method_name = tp.method_id}.enable
      test
      method_name.should equal(:test)
    end
  end
end
