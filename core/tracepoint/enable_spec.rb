require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is '2.0' do
  describe 'TracePoint#enable' do
    def test; end

    it 'returns true if trace was enabled' do
      event_name, method_name = nil, nil
      trace = TracePoint.new(:call) do |tp|
        event_name = tp.event
        method_name = tp.method_id
      end

      event_name.should equal(nil)
      test
      method_name.equal?(:test).should be_false

      trace.enable
      trace.enable.should be_true
      event_name.should equal(:call)
      test
      method_name.equal?(:test).should be_true
      trace.disable
    end

    it 'returns false if trace was disabled' do
      event_name, method_name = nil, nil
      trace = TracePoint.new(:call) do |tp|
        event_name = tp.event
        method_name = tp.method_id
      end

      trace.enable.should be_false
      event_name.should equal(:call)
      test
      method_name.equal?(:test).should be_true

      trace.disable
      event_name, method_name = nil
      test
      method_name.equal?(:test).should be_false
      event_name.should equal(nil)

      trace.enable.should be_false
      event_name.should equal(:call)
      test
      method_name.equal?(:test).should be_true
      trace.disable
    end

    it 'is enabled within a block' do
      event_name = nil
      TracePoint.new(:line) do |tp|
        event_name = tp.event
      end.enable { event_name.should equal(:line) }
    end

    ruby_bug "#14057", "2.0"..."2.5" do
      it 'can accept param within a block but it should not yield arguments' do
        event_name = nil
        trace = TracePoint.new(:line) { |tp| event_name = tp.event }
        trace.enable do |*args|
          event_name.should equal(:line)
          args.should == []
        end
        trace.enabled?.should be_false
      end
    end

    it 'is enabled on calling with a block if it was already enabled' do
      enabled = nil
      trace = TracePoint.new(:line) {}
      trace.enable
      trace.enabled?.should be_true
      trace.enable { enabled = trace.enabled? }
      enabled.should be_true
      trace.disable
    end

    it 'is enabled within a block & also returns true when its called with a block' do
      trace = TracePoint.new(:line) {}
      trace.enable { trace.enabled? }.should == true
      trace.enabled?.should be_false
    end

    it 'is disabled after the block & expects the result of enable {} to equal
      nil' do
      event_name = nil
      trace = TracePoint.new(:line) { |tp|event_name = tp.event }
      trace.enable { event_name.should equal(:line) }.should == nil
      trace.enabled?.should be_false
      trace.disable
    end
  end
end
