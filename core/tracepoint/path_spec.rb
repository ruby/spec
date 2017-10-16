require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is '2.0' do
  describe 'TracePoint#path' do
    it 'returns the path of the file being run' do
      path = nil
      TracePoint.new(:line) { |tp| path = tp.path }.enable
      path.should == "#{__FILE__}"
    end
  end
end
