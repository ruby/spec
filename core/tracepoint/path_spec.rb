require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is '2.0' do
  describe 'TracePoint#path' do
    it 'returns the path of the file being run' do
      path = nil
      TracePoint.new(:line) { |tp| path = tp.path }.enable
      path.should == "#{__FILE__}"
    end

    it 'equals (eval) inside an eval' do
      path = nil
      TracePoint.new(:end) { |tp| path = tp.path }.enable
      eval("class A; end")
      path.should == '(eval)'
    end
  end
end
