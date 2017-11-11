require File.expand_path('../../../spec_helper', __FILE__)

describe 'TracePoint#lineno' do
  it 'returns the line number of the event' do
    lineno = nil
    TracePoint.new(:line) { |tp| lineno = tp.lineno }.enable do
      lineno.should equal(8)
    end
  end
end
