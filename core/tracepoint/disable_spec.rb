require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is '2.0' do
  describe 'TracePoint#disable' do
    def test; end
    it 'returns true if trace was enabled' do
      event_name, method_name = nil
      trace = TracePoint.new(:call) do |tp|
        event_name = tp.event
        method_name = tp.method_id
      end

      trace.enable
      trace.disable.should be_true
      event_name, method_name = nil
      test
      method_name.equal?(:test).should be_false
      event_name.should equal(nil)
    end

    it 'returns false if trace was disabled' do
      event_name, method_name = nil
      trace = TracePoint.new(:call) do |tp|
        event_name = tp.event
        method_name = tp.method_id
      end

      trace.disable.should be_false
      event_name, method_name = nil
      test
      method_name.equal?(:test).should be_false
      event_name.should equal(nil)
    end
  end
end
