require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is '2.4' do
  describe 'TracePoint#binding' do
    it 'return the generated binding object from event' do
      binding = nil
      TracePoint.new(:line) { |tp| binding = tp.binding }.enable
      binding.should be_kind_of(Binding)
    end
  end
end
