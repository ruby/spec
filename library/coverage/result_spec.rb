require File.expand_path('../../../spec_helper', __FILE__)
require fixture __FILE__, 'spec_helper'
require 'coverage'

describe 'Coverage.result' do
  extend Coverage::SpecHelper
  before :all do
    @class_file = fixture __FILE__, 'some_class.rb'
    @config_file = fixture __FILE__, 'start_coverage.rb'
  end

  after :each do
    $LOADED_FEATURES.delete(@class_file)
    $LOADED_FEATURES.delete(@config_file)
  end

  it 'gives the covered files as a hash with arrays of count or nil' do
    Coverage.start
    require @class_file.chomp('.rb')
    result = filtered_result

    result.should == {
      @class_file => [
        nil, nil, 1, nil, nil, 1, nil, nil, 0, nil, nil, nil, nil, nil, nil, nil
      ]
    }
  end

  it 'no requires/loads should give empty hash' do
    Coverage.start
    result = filtered_result

    result.should == {}
  end

  it 'second call should give exception' do
    Coverage.start
    require @class_file.chomp('.rb')
    Coverage.result
    begin
      Coverage.result
      fails 'Second call should give an exception'
    rescue RuntimeError
      $!.message.should == 'coverage measurement is not enabled'
    end
  end

  it 'second run should give same result' do
    Coverage.start
    load @class_file
    result1 = filtered_result

    Coverage.start
    load @class_file
    result2 = filtered_result

    result2.should == result1
  end

  it 'second run without load/require should give empty hash' do
    Coverage.start
    require @class_file.chomp('.rb')
    Coverage.result

    Coverage.start
    result = filtered_result

    result.should == {}
  end

  it 'second Coverage.start does nothing' do
    Coverage.start
    require @config_file.chomp('.rb')
    result = filtered_result

    result.should == { @config_file => [1, 1, 1] }
  end

  it 'should list coverage for the required file starting coverage' do
    require @config_file.chomp('.rb')
    result = Coverage.result.select{ |k,v| v.any? || k == @config_file }

    result.should == { @config_file => [] }
  end

  it 'should list coverage for the loaded file starting coverage' do
    load @config_file
    result = Coverage.result.select{ |k,v| v.any? || k == @config_file }

    result.should == { @config_file => [] }
  end
end
