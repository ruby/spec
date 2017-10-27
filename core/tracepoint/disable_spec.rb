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

    it 'is disabled within a block' do
      event_name = nil
      trace = TracePoint.new(:line) {}
      trace.enable
      trace.disable { puts 2 + 2 }.should == nil
      trace.enabled?.should equal(true)
      trace.disable
    end

    ruby_bug "#14057", "2.0"..."2.5" do
      it 'can accept param within a block but it should not yield arguments' do
        event_name = nil
        trace = TracePoint.new(:line) {}
        trace.enable
        trace.disable do |*args|
          args.should == []
        end
        trace.enabled?.should be_true
        trace.disable
      end
    end
  end
end
