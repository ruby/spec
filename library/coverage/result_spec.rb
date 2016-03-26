require File.expand_path('../../../spec_helper', __FILE__)
require 'coverage'

describe 'Coverage.result' do
  before :all do
    @config_file = fixture __FILE__, 'start_coverage.rb'
  end

  after :each do
    $LOADED_FEATURES.delete(@config_file)
  end

  it 'gives the covered files as a hash with arrays' do
    Coverage.start
    require @config_file.chomp('.rb')
    result = Coverage.result

    result.should == { @config_file => [1, 1, 1] }
  end

  it 'should list coverage for the required file starting coverage' do
    require @config_file.chomp('.rb')
    result = Coverage.result

    result.should == { @config_file => [] }
  end

  it 'should list coverage for the loaded file starting coverage' do
    load @config_file
    result = Coverage.result

    result.should == { @config_file => [] }
  end
end
