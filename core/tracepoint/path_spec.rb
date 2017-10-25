require File.expand_path('../../../spec_helper', __FILE__)

def test; 'test' end

ruby_version_is '2.0' do
  describe 'TracePoint#path' do
    it 'returns the path of the file being run' do
      path = nil
      TracePoint.new(:line) { |tp| path = tp.path }.enable do
        path.should == "#{__FILE__}"
      end
    end

    it 'equals (eval) inside an eval for :end event' do
      path = nil
      TracePoint.new(:end) { |tp| path = tp.path }.enable do
        eval("class A; end")
        path.should == '(eval)'
      end
    end

    it 'equals the path of the file being run for :line event inside an eval' do
      path = nil
      TracePoint.new(:line) { |tp| path = tp.path }.enable do
        eval("2 + 2")
        path.should == "#{__FILE__}"
      end
    end

    it 'equals the path of the file being run for :call event inside an eval' do
      path = nil
      TracePoint.new(:call) { |tp| path = tp.path }.enable do
        eval("test")
        path.should == "#{__FILE__}"
      end
    end

    it 'equals the path of the file being run for :return event inside an eval' do
      path = nil
      TracePoint.new(:return) { |tp| path = tp.path }.enable do
        eval("test")
        path.should == "#{__FILE__}"
      end
    end
  end
end
